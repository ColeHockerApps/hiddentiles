import Combine
import SwiftUI

final class SettingsViewModel: ObservableObject {
    @Published var animationsEnabled: Bool = true
    @Published var soundEnabled: Bool = true
    @Published var hapticsEnabled: Bool = true

    func toggleAnimations() {
        animationsEnabled.toggle()
        HapticsManager.shared.choose()
    }

    func toggleSound() {
        soundEnabled.toggle()
        HapticsManager.shared.choose()
    }

    func toggleHaptics() {
        hapticsEnabled.toggle()
        HapticsManager.shared.choose()
    }

    func close(flow: ScreenFlow) {
        HapticsManager.shared.tapSoft()
        flow.closeCurrent()
    }
}
