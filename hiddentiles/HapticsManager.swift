import Combine
import SwiftUI

final class HapticsManager {
    static let shared = HapticsManager()

    private let soft = UIImpactFeedbackGenerator(style: .light)
    private let medium = UIImpactFeedbackGenerator(style: .medium)
    private let heavy = UIImpactFeedbackGenerator(style: .heavy)
    private let select = UISelectionFeedbackGenerator()
    private let notifySuccess = UINotificationFeedbackGenerator()

    private init() {
        prepare()
    }

    private func prepare() {
        soft.prepare()
        medium.prepare()
        heavy.prepare()
        select.prepare()
        notifySuccess.prepare()
    }

    func tapSoft() {
        soft.impactOccurred(intensity: 0.4)
    }

    func tapMedium() {
        medium.impactOccurred(intensity: 0.7)
    }

    func tapHeavy() {
        heavy.impactOccurred(intensity: 1.0)
    }

    func choose() {
        select.selectionChanged()
    }

    func complete() {
        notifySuccess.notificationOccurred(.success)
    }
}
