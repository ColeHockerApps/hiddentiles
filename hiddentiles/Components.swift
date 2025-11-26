import Combine
import SwiftUI

struct SoftButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    let gradient: LinearGradient

    @State private var pressed: Bool = false

    var body: some View {
        Button {
            HapticsManager.shared.tapSoft()
            action()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(gradient)
                    .shadow(color: .black.opacity(0.12), radius: 12, x: 0, y: 6)
                    .scaleEffect(pressed ? 0.96 : 1)

                HStack(spacing: 10) {
                    if let icon = icon {
                        Image(systemName: icon)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                    }

                    Text(title)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 22)
                .padding(.vertical, 14)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in pressed = true }
                .onEnded { _ in pressed = false }
        )
        .animation(.spring(response: 0.35, dampingFraction: 0.7), value: pressed)
    }
}

struct SoftTile: View {
    let title: String

    var body: some View {
        RoundedRectangle(cornerRadius: 20, style: .continuous)
            .fill(ColorTokens.surfaceDim)
            .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 4)
            .overlay(
                Text(title)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(ColorTokens.textMain)
            )
    }
}

struct GlowIcon: View {
    let systemName: String
    let size: CGFloat

    var body: some View {
        Image(systemName: systemName)
            .font(.system(size: size, weight: .regular))
            .foregroundColor(ColorTokens.primaryA)
            .shadow(color: ColorTokens.glow.opacity(0.5), radius: 10, x: 0, y: 4)
    }
}

struct BackButton: View {
    let action: () -> Void

    var body: some View {
        Button {
            HapticsManager.shared.tapSoft()
            action()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: AppIcons.back)
                    .font(.system(size: 16, weight: .semibold))

                Text("Back")
                    .font(.system(size: 17, weight: .semibold))
            }
            .foregroundColor(ColorTokens.textMain)
            .padding(.horizontal, 18)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(ColorTokens.surfaceDim)
                    .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 3)
            )
        }
    }
}
