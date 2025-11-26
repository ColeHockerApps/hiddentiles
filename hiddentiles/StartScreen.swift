import Combine
import SwiftUI

struct StartScreen: View {
    @EnvironmentObject private var theme: GameTheme
    @EnvironmentObject private var flow: ScreenFlow
    @StateObject private var vm = StartViewModel()

    var body: some View {
        ZStack {
            theme.backgroundGradient
                .ignoresSafeArea()

            EffectsLayer()

            VStack(spacing: 28) {
                Spacer(minLength: 40)

                if vm.showTitle {
                    logoBlock
                        .transition(.opacity.combined(with: .scale))
                }

                Spacer()

                if vm.showButtons {
                    playButton
                        .transition(.scale.combined(with: .opacity))

                    VStack(spacing: 14) {
                        menuButton(title: "Settings", icon: AppIcons.settings) {
                            vm.handleSettingsTap(flow: flow)
                        }
                        menuButton(title: "How to Play", icon: AppIcons.rules) {
                            vm.handleRulesTap(flow: flow)
                        }
                        menuButton(title: "Privacy", icon: AppIcons.privacy) {
                            vm.handlePrivacyTap(flow: flow)
                        }
                        menuButton(title: "Rate Us", icon: AppIcons.rate) {
                            HapticsManager.shared.tapSoft()
                            RateManager.shared.askFromButton()
                        }
                    }
                    .padding(.bottom, 48)
                }
            }
            .padding(.horizontal, 32)
        }
        .onAppear { vm.handleAppear() }
    }

    // MARK: - Logo

    private var logoBlock: some View {
        VStack(spacing: 10) {
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 260)
                .shadow(color: ColorTokens.glow.opacity(0.6), radius: 20, x: 0, y: 8)
                .scaleEffect(vm.showTitle ? 1 : 0.9)
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: vm.showTitle)

            Text(vm.subtitleText)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(ColorTokens.textSoft)
        }
    }

    // MARK: - Play Button

    private var playButton: some View {
        Button {
            HapticsManager.shared.tapMedium()
            vm.handlePlayTap(flow: flow)
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .fill(theme.primaryButtonGradient)
                    .frame(height: 80)
                    .shadow(color: ColorTokens.glow.opacity(0.55), radius: 18, x: 0, y: 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 32, style: .continuous)
                            .stroke(Color.white.opacity(0.25), lineWidth: 1.2)
                    )

                HStack(spacing: 10) {
                    Image(systemName: AppIcons.play)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)

                    Text("Play")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.white)
                }
                .shadow(color: .black.opacity(0.25), radius: 4, x: 1, y: 2)
            }
            .padding(.top, 12)
            .scaleEffect(vm.showButtons ? 1 : 0.9)
            .animation(.spring(response: 0.55, dampingFraction: 0.7), value: vm.showButtons)
        }
    }

    // MARK: - Menu Button

    private func menuButton(title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button {
            HapticsManager.shared.tapSoft()
            action()
        } label: {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(ColorTokens.textMain)

                Text(title)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(ColorTokens.textMain)

                Spacer()
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(ColorTokens.surfaceDim)
                    .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 3)
            )
        }
    }
}
