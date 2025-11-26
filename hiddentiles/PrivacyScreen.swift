import Combine
import SwiftUI

struct PrivacyScreen: View {
    @EnvironmentObject private var theme: GameTheme
    @EnvironmentObject private var flow: ScreenFlow
    @EnvironmentObject private var levels: Levels
    @StateObject private var vm = PrivacyViewModel()

    @State private var isLoaded: Bool = false
    @State private var showOverlay: Bool = true

    var body: some View {
        ZStack {
            theme.backgroundGradient
                .ignoresSafeArea()

            EffectsLayer()

            Color.black
                .opacity(0.22)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                header
                    .padding(.top, 28)
                    .padding(.horizontal, 26)

                Spacer()

                boardBlock
                    .padding(.horizontal, 26)
                    .frame(maxWidth: 600, maxHeight: .infinity)

                Spacer()

                closeButton
                    .padding(.bottom, 28)
                    .padding(.horizontal, 26)
            }
            .opacity(vm.fadeIn ? 1 : 0)
            .animation(.easeOut(duration: 0.3), value: vm.fadeIn)

            if showOverlay && !isLoaded {
                loadingOverlay
                    .transition(.opacity)
            }
        }
        .onAppear {
            vm.onAppear()
            isLoaded = false
            showOverlay = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                if !isLoaded {
                    withAnimation(.easeOut(duration: 0.25)) {
                        showOverlay = false
                    }
                }
            }
        }
        .onChange(of: isLoaded) { loaded in
            if loaded {
                withAnimation(.easeOut(duration: 0.25)) {
                    showOverlay = false
                }
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            Text(vm.title)
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(ColorTokens.textMain)
                .shadow(color: ColorTokens.glow.opacity(0.35), radius: 8, x: 0, y: 3)

            Spacer()
        }
    }

    // MARK: - Board

    private var boardBlock: some View {
        GameBoardView(
            startAddress: levels.privacyAddress,
            levels: levels
        ) {
            isLoaded = true
        }
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.12), radius: 10, x: 0, y: 4)
    }

    // MARK: - Loading

    private var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.12)
                .ignoresSafeArea()

            VStack(spacing: 14) {
                ProgressView()
                    .tint(ColorTokens.primaryA)

                Text("Opening…")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(ColorTokens.textMain)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(ColorTokens.surfaceDim)
                    .shadow(color: Color.black.opacity(0.18), radius: 12, x: 0, y: 6)
            )
        }
    }

    // MARK: - Close

    private var closeButton: some View {
        Button {
            vm.close(flow: flow)
        } label: {
            HStack(spacing: 10) {
                Image(systemName: AppIcons.back)
                    .font(.system(size: 16, weight: .semibold))

                Text("Back")
                    .font(.system(size: 17, weight: .semibold))
            }
            .foregroundColor(ColorTokens.textMain)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(ColorTokens.surfaceDim)
                    .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 3)
            )
        }
    }
}
