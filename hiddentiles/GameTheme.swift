import Combine
import SwiftUI

final class GameTheme: ObservableObject {
    @Published var isDark: Bool = false

    struct Palette {
        let backgroundTop: Color
        let backgroundBottom: Color
        let primary: Color
        let secondary: Color
        let accent: Color
        let surface: Color
        let surfaceSoft: Color
        let textMain: Color
        let textSoft: Color
        let glow: Color

        init(isDark: Bool) {
            if isDark {
                backgroundTop = Color(red: 8/255, green: 10/255, blue: 26/255)
                backgroundBottom = Color(red: 30/255, green: 18/255, blue: 56/255)
                primary = Color(red: 244/255, green: 214/255, blue: 120/255)
                secondary = Color(red: 130/255, green: 206/255, blue: 190/255)
                accent = Color(red: 220/255, green: 120/255, blue: 230/255)
                surface = Color(red: 18/255, green: 20/255, blue: 40/255)
                surfaceSoft = Color(red: 28/255, green: 30/255, blue: 54/255)
                textMain = Color.white
                textSoft = Color.white.opacity(0.7)
                glow = Color(red: 255/255, green: 230/255, blue: 160/255)
            } else {
                backgroundTop = Color(red: 227/255, green: 244/255, blue: 255/255)
                backgroundBottom = Color(red: 171/255, green: 201/255, blue: 255/255)
                primary = Color(red: 240/255, green: 158/255, blue: 84/255)
                secondary = Color(red: 120/255, green: 192/255, blue: 174/255)
                accent = Color(red: 205/255, green: 120/255, blue: 230/255)
                surface = Color.white
                surfaceSoft = Color.white.opacity(0.9)
                textMain = Color(red: 20/255, green: 26/255, blue: 46/255)
                textSoft = Color.black.opacity(0.6)
                glow = Color(red: 255/255, green: 220/255, blue: 150/255)
            }
        }
    }

    var palette: Palette {
        Palette(isDark: isDark)
    }

    var background: Color {
        Color.clear
    }

    var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [palette.backgroundTop, palette.backgroundBottom],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    var tileGlowGradient: RadialGradient {
        RadialGradient(
            gradient: Gradient(colors: [
                palette.glow.opacity(0.6),
                palette.glow.opacity(0),
            ]),
            center: .center,
            startRadius: 0,
            endRadius: 160
        )
    }

    var primaryButtonGradient: LinearGradient {
        LinearGradient(
            colors: [
                palette.primary,
                palette.accent
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    var secondaryButtonGradient: LinearGradient {
        LinearGradient(
            colors: [
                palette.secondary,
                palette.accent.opacity(0.8)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    func toggleStyle() {
        isDark.toggle()
    }
}
