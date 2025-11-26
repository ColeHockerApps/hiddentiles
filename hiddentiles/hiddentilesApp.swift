import SwiftUI
import Combine

@main
struct HiddenTilesSagaApp: App {
    @StateObject private var levels = Levels()
    @StateObject private var theme = GameTheme()
    @StateObject private var flow = ScreenFlow()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(levels)
                .environmentObject(theme)
                .environmentObject(flow)
        }
    }
}

private struct RootView: View {
    @EnvironmentObject private var theme: GameTheme
    @EnvironmentObject private var flow: ScreenFlow

    @State private var fadeIn: CGFloat = 0

    var body: some View {
        ZStack {
            theme.background
                .ignoresSafeArea()

            currentScreen
                .opacity(fadeIn)
                .animation(.easeOut(duration: 0.35), value: fadeIn)
        }
        .onAppear {
            fadeIn = 1
        }
    }

    @ViewBuilder
    private var currentScreen: some View {
        switch flow.current {
        case .start:
            StartScreen()
        case .settings:
            SettingsScreen()
        case .rules:
            RulesScreen()
        case .privacy:
            PrivacyScreen()
        case .play:
            PlayContainer()
        }
    }
}
