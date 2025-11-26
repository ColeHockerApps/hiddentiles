import Combine
import SwiftUI

enum ColorTokens {
    static let bgTop      = Color(red: 0.92, green: 0.97, blue: 1.00)
    static let bgBottom   = Color(red: 0.74, green: 0.86, blue: 1.00)

    static let primaryA   = Color(red: 0.96, green: 0.74, blue: 0.38)
    static let primaryB   = Color(red: 0.94, green: 0.56, blue: 0.85)

    static let softA      = Color(red: 0.55, green: 0.80, blue: 0.66)
    static let softB      = Color(red: 0.61, green: 0.72, blue: 1.00)

    static let surface    = Color.white
    static let surfaceDim = Color.white.opacity(0.85)

    static let textMain   = Color(red: 0.10, green: 0.13, blue: 0.24)
    static let textSoft   = Color.black.opacity(0.5)

    static let glow       = Color(red: 1.00, green: 0.87, blue: 0.60)
    static let glowSoft   = Color(red: 1.00, green: 0.95, blue: 0.80)
}
