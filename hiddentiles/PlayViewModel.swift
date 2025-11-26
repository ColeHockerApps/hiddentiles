import Combine
import SwiftUI

final class PlayViewModel: ObservableObject {
    @Published var isReady: Bool = false
    @Published var fadeIn: Bool = false

    @Published var showLeavePrompt: Bool = false
    private var leaveAction: (() -> Void)?

    func onAppear() {
        withAnimation(.easeOut(duration: 0.35)) {
            fadeIn = true
        }
    }

    func markReady() {
        withAnimation(.easeOut(duration: 0.25)) {
            isReady = true
        }
    }

    // MARK: - Leaving the board

    func requestLeave(flow: ScreenFlow) {
        HapticsManager.shared.tapSoft()
        leaveAction = { [weak flow] in
            flow?.closeCurrent()
        }
        showLeavePrompt = true
    }

    func cancelLeave() {
        HapticsManager.shared.tapSoft()
        showLeavePrompt = false
        leaveAction = nil
    }

    func confirmLeave() {
        HapticsManager.shared.tapMedium()
        showLeavePrompt = false
        leaveAction?()
        leaveAction = nil
    }

    // MARK: - Direct close (used where allowed)

    func closeDirect(flow: ScreenFlow) {
        HapticsManager.shared.tapSoft()
        flow.closeCurrent()
    }
}
