import Combine
import SwiftUI

final class RulesViewModel: ObservableObject {
    @Published var fadeIn: Bool = false

    let title: String = "How to Play"
    let lines: [String] = [
        "Find matching symbols.",
        "Tap pairs to clear them.",
        "Clear the board to win.",
        "Relax and enjoy the flow."
    ]

    func onAppear() {
        withAnimation(.easeOut(duration: 0.35)) {
            fadeIn = true
        }
    }

    func close(flow: ScreenFlow) {
        HapticsManager.shared.tapSoft()
        flow.closeCurrent()
    }
}
