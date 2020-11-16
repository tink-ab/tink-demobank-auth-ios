import SwiftUI

struct BackgroundView: View {

    private let fractionFilled: CGFloat = 0.703
    private let backgroundColor = Color.background
    private let shapeColor = Color.button

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                backgroundColor
                VStack {
                    BackgroundShape().frame(width: geometry.size.width, height: geometry.size.height * fractionFilled).foregroundColor(shapeColor)
                    Spacer()
                }
            }
        }
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}
