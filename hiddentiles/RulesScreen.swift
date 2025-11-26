import Combine
import SwiftUI

struct RulesScreen: View {
    @EnvironmentObject private var theme: GameTheme
    @EnvironmentObject private var flow: ScreenFlow
    @StateObject private var vm = RulesViewModel()

    var body: some View {
        ZStack {
            theme.backgroundGradient
                .ignoresSafeArea()

            EffectsLayer()

            VStack(spacing: 26) {
                header
                    .padding(.top, 28)
                    .padding(.horizontal, 26)

                Spacer()

                rulesBlock
                    .padding(.horizontal, 28)

                Spacer()

                closeButton
                    .padding(.bottom, 28)
                    .padding(.horizontal, 26)
            }
            .opacity(vm.fadeIn ? 1 : 0)
            .animation(.easeOut(duration: 0.3), value: vm.fadeIn)
        }
        .onAppear {
            vm.onAppear()
        }
    }

    private var header: some View {
        HStack {
            Text(vm.title)
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(ColorTokens.textMain)
                .shadow(color: ColorTokens.glow.opacity(0.35), radius: 8, x: 0, y: 3)

            Spacer()
        }
    }

    private var rulesBlock: some View {
        VStack(alignment: .leading, spacing: 18) {
            ForEach(vm.lines, id: \.self) { line in
                HStack(alignment: .top, spacing: 10) {
                    Circle()
                        .fill(ColorTokens.primaryA.opacity(0.8))
                        .frame(width: 10, height: 10)
                        .shadow(color: ColorTokens.glow.opacity(0.5), radius: 4)

                    Text(line)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(ColorTokens.textMain)
                }
            }
        }
        .frame(maxWidth: 520)
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
