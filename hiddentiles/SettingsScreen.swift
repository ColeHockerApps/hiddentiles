import Combine
import SwiftUI

struct SettingsScreen: View {
    @EnvironmentObject private var theme: GameTheme
    @EnvironmentObject private var flow: ScreenFlow
    @StateObject private var vm = SettingsViewModel()

    @State private var fadeIn: Bool = false

    var body: some View {
        ZStack {
            theme.backgroundGradient
                .ignoresSafeArea()

            EffectsLayer()

            VStack {
                header
                    .padding(.top, 24)
                    .padding(.horizontal, 24)

                Spacer()

                content
                    .padding(.horizontal, 24)

                Spacer()

                closeButton
                    .padding(.bottom, 28)
                    .padding(.horizontal, 24)
            }
            .opacity(fadeIn ? 1 : 0)
            .animation(.easeOut(duration: 0.3), value: fadeIn)
        }
        .onAppear {
            fadeIn = true
        }
    }

    private var header: some View {
        HStack {
            Text("Settings")
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(ColorTokens.textMain)
                .shadow(color: ColorTokens.glow.opacity(0.4), radius: 8, x: 0, y: 3)

            Spacer()
        }
    }

    private var content: some View {
        VStack(spacing: 18) {
            settingRow(
                title: "Animations",
                subtitle: "Soft movements and glow effects",
                isOn: $vm.animationsEnabled
            ) {
                vm.toggleAnimations()
            }

//            settingRow(
//                title: "Sound",
//                subtitle: "Game music and effects",
//                isOn: $vm.soundEnabled
//            ) {
//                vm.toggleSound()
//            }

            settingRow(
                title: "Haptics",
                subtitle: "Gentle vibration on actions",
                isOn: $vm.hapticsEnabled
            ) {
                vm.toggleHaptics()
            }
        }
        .frame(maxWidth: 520)
    }

    private func settingRow(
        title: String,
        subtitle: String,
        isOn: Binding<Bool>,
        action: @escaping () -> Void
    ) -> some View {
        Button {
            action()
        } label: {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(ColorTokens.textMain)

                    Text(subtitle)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(ColorTokens.textSoft)
                }

                Spacer()

                Capsule()
                    .fill(
                        LinearGradient(
                            colors: isOn.wrappedValue
                            ? [ColorTokens.primaryA, ColorTokens.primaryB]
                            : [ColorTokens.surfaceDim, ColorTokens.surfaceDim],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 58, height: 30)
                    .overlay(
                        Circle()
                            .fill(Color.white)
                            .frame(width: 24, height: 24)
                            .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 1)
                            .offset(x: isOn.wrappedValue ? 12 : -12)
                            .animation(.spring(response: 0.32, dampingFraction: 0.8), value: isOn.wrappedValue)
                    )
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(ColorTokens.surfaceDim)
                    .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 4)
            )
        }
    }

    private var closeButton: some View {
        Button {
            vm.close(flow: flow)
        } label: {
            HStack(spacing: 10) {
                Image(systemName: AppIcons.back)
                    .font(.system(size: 16, weight: .semibold))

                Text("Back")
                    .font(.system(size: 17, weight: .semibold))
            }
            .foregroundColor(ColorTokens.textMain)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(ColorTokens.surfaceDim)
                    .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 3)
            )
        }
    }
}
