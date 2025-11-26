import Combine
import SwiftUI

final class ScreenFlow: ObservableObject {
    @Published var current: GameScreen = .start

    func openStart() {
        current = .start
    }

    func openSettings() {
        HapticsManager.shared.tapSoft()
        current = .settings
    }

    func openRules() {
        HapticsManager.shared.tapSoft()
        current = .rules
    }

    func openPrivacy() {
        HapticsManager.shared.tapSoft()
        current = .privacy
    }

    func openPlay() {
        HapticsManager.shared.tapMedium()
        RateManager.shared.registerPlaySession()
        current = .play
    }

    func closeCurrent() {
        current = .start
    }
}
