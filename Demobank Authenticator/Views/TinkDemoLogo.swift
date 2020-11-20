import SwiftUI

struct TinkDemoLogo: View {
    var body: some View {
        ZStack {
            Circle().fill(Color.tinkDark)
            RectShape().fill(Color.tinkLight)
            DShape().fill(Color.leftToSpend)
        }
    }
}

private struct RectShape: Shape {
    func path(in rect: CGRect) -> Path {
        let radius = min(rect.midY, rect.midX)
        let center = CGPoint(x: rect.midX, y: rect.midY)

        let width: CGFloat = 0.26 * radius
        let spacing: CGFloat = width / 2

        return Path(CGRect(x: center.x - width - spacing, y: center.y - radius * 0.6, width: width, height: radius * 2 * 0.6))
    }
}

private struct DShape: Shape {
    func path(in rect: CGRect) -> Path {
        let radius = min(rect.midY, rect.midX)
        let center = CGPoint(x: rect.midX, y: rect.midY)

        let width: CGFloat = 0.26 * radius

        var path = Path()

        let bigRadius = radius * 0.6
        let smallRadius = bigRadius - width

        path.addArc(
            center: center,
            radius: bigRadius,
            startAngle: Angle(radians: -.pi/2),
            endAngle: Angle(radians: .pi/2),
            clockwise: false
        )

        path.addArc(
            center: center,
            radius: smallRadius,
            startAngle: Angle(radians: .pi/2),
            endAngle: Angle(radians: -.pi/2),
            clockwise: true
        )

        path.closeSubpath()

        return path
    }
}

struct TinkDemoLogo_Previews: PreviewProvider {
    static var previews: some View {
        TinkDemoLogo()
    }
}
