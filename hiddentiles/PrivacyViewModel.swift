import Combine
import SwiftUI

final class PrivacyViewModel: ObservableObject {
    @Published var fadeIn: Bool = false

    let title: String = "Privacy Policy"

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
