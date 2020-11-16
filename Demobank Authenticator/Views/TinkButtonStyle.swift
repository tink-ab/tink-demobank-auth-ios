import SwiftUI

struct TinkButtonStyle: ButtonStyle {

    var foreground = Color.white
    var background = Color.button

    func makeBody(configuration: ButtonStyleConfiguration) -> some View {
        Capsule()
            .fill(background.opacity(configuration.isPressed ? 0.7 : 1))
            .overlay(configuration.label.foregroundColor(foreground).opacity(configuration.isPressed ? 0.7 : 1))
            .frame(width: 200,  height: 50)
    }
}
