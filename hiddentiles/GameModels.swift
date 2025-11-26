import Combine
import SwiftUI

enum GameScreen: Equatable {
    case start
    case settings
    case rules
    case privacy
    case play
}

struct GameButtonStyle {
    let gradient: LinearGradient
    let corner: CGFloat
    let shadow: CGFloat
}

struct LightEffect: Identifiable {
    let id = UUID()
    let position: CGPoint
    let radius: CGFloat
    let opacity: Double
}

final class GameState: ObservableObject {
    @Published var sessionCount: Int = 0
    @Published var lastAction: Date = Date()
}
