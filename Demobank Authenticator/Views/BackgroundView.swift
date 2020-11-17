import SwiftUI

struct BackgroundView: View {

    let color: Color
    private let fractionFilled: CGFloat = 0.703
    private let backgroundColor = Color.background

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                backgroundColor
                VStack {
                    BackgroundShape().frame(width: geometry.size.width, height: geometry.size.height * fractionFilled).foregroundColor(color)
                    Spacer()
                }
            }
        }
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView(color: .button)
    }
}
