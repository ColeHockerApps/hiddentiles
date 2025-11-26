import Combine
import SwiftUI

final class StartViewModel: ObservableObject {
    @Published var didAppear: Bool = false
    @Published var showTitle: Bool = false
    @Published var showButtons: Bool = false

    let titleText: String = "Hidden Tiles Saga"
    let subtitleText: String = "Match pairs, relax, enjoy the journey"

    func handleAppear() {
        guard didAppear == false else { return }
        didAppear = true

        withAnimation(.easeOut(duration: 0.4)) {
            showTitle = true
        }

        withAnimation(.easeOut(duration: 0.5).delay(0.15)) {
            showButtons = true
        }
    }

    func handlePlayTap(flow: ScreenFlow) {
        flow.openPlay()
    }

    func handleSettingsTap(flow: ScreenFlow) {
        flow.openSettings()
    }

    func handleRulesTap(flow: ScreenFlow) {
        flow.openRules()
    }

    func handlePrivacyTap(flow: ScreenFlow) {
        flow.openPrivacy()
    }
}
