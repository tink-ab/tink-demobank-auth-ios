import SwiftUI

struct BackgroundShape: Shape {

    func path(in rect: CGRect) -> Path {

        let curveHeight: CGFloat = 40
        let p1 = CGPoint(x: rect.maxX, y: rect.minY)
        let p2 = CGPoint(x: rect.maxX, y: rect.maxY - curveHeight)
        let pMid = CGPoint(x: rect.midX, y: rect.maxY)
        let p3 = CGPoint(x: rect.minY, y: rect.maxY - curveHeight)

        let (center, radius) = circle(inPoint: p2, secondPoint: pMid, thirdPoint: p3)
        let startAngle = angle(p1: p2, p2: center)
        let endAngle = angle(p1: p3, p2: center)

        return Path { p in
            p.move(to: rect.origin)
            p.addLine(to: p1)
            p.addLine(to: p2)
            p.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            p.addLine(to: rect.origin)
        }
    }
    
    private func circle(inPoint p1: CGPoint, secondPoint p2: CGPoint, thirdPoint p3: CGPoint) -> (CGPoint, CGFloat) {

        let v1 = CGVector(dx: p2.x - p1.x, dy: p2.y - p1.y)
        let v2 = CGVector(dx: p3.x - p2.x, dy: p3.y - p2.y)

        let v1Slope = v1.dy / v1.dx
        let v2Slope = v2.dy / v2.dx

        var center = CGPoint.zero
        center.x = (v1Slope * v2Slope * (p1.y - p3.y) + v2Slope * (p1.x + p2.x) - v1Slope * (p2.x + p3.x) ) / (2 * (v2Slope - v1Slope))
        center.y = -1 * (center.x - (p1.x + p2.x) / 2) / v1Slope + (p1.y + p2.y) / 2

        let radius = ((p1.x - center.x) * (p1.x - center.x) + (p1.y - center.y) * (p1.y - center.y)).squareRoot()

        return (center, radius)
    }

    private func angle(p1: CGPoint, p2: CGPoint) -> Angle {
        let Δx = p1.x - p2.x
        let Δy = p1.y - p2.y
        return Angle(radians: Double(atan2(Δy, Δx)))
    }
}
