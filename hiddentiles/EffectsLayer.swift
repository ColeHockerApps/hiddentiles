import Combine
import SwiftUI

struct EffectsLayer: View {
    @State private var sparks: [Spark] = []
    private let timer = Timer.publish(every: 0.7, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            ForEach(sparks) { spark in
                Circle()
                    .fill(spark.color.opacity(spark.opacity))
                    .frame(width: spark.size, height: spark.size)
                    .position(spark.position)
                    .blur(radius: 10)
                    .blendMode(.plusLighter)
                    .animation(.easeOut(duration: spark.life), value: spark.opacity)
            }

            RadialGradient(
                gradient: Gradient(colors: [
                    ColorTokens.glowSoft.opacity(0.35),
                    .clear
                ]),
                center: .center,
                startRadius: 0,
                endRadius: 260
            )
            .allowsHitTesting(false)
        }
        .allowsHitTesting(false)
        .onReceive(timer) { _ in
            addSpark()
        }
    }

    private func addSpark() {
        let bounds = UIScreen.main.bounds

        let size = CGFloat.random(in: 18...34)
        let x = CGFloat.random(in: bounds.minX + 20 ... bounds.maxX - 20)
        let y = CGFloat.random(in: bounds.minY + 40 ... bounds.maxY - 40)

        let spark = Spark(
            position: CGPoint(x: x, y: y),
            size: size,
            color: randomColor(),
            opacity: Double.random(in: 0.55...0.85),
            life: Double.random(in: 1.8...2.6)
        )

        sparks.append(spark)

        DispatchQueue.main.asyncAfter(deadline: .now() + spark.life) {
            if let index = sparks.firstIndex(where: { $0.id == spark.id }) {
                sparks.remove(at: index)
            }
        }
    }

    private func randomColor() -> Color {
        let options: [Color] = [
            ColorTokens.primaryA,
            ColorTokens.primaryB,
            ColorTokens.softA,
            ColorTokens.softB,
            ColorTokens.glow
        ]
        return options.randomElement() ?? .white
    }
}

struct Spark: Identifiable {
    let id = UUID()
    let position: CGPoint
    let size: CGFloat
    let color: Color
    let opacity: Double
    let life: Double
}
