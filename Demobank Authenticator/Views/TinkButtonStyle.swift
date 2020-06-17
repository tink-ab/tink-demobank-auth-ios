import SwiftUI

struct TinkButtonStyle: ButtonStyle {

    var foreground = Color.white
    var background = Color.tinkPrimary

    func makeBody(configuration: ButtonStyleConfiguration) -> some View {
        Capsule()
            .fill(background.opacity(configuration.isPressed ? 0.8 : 1))
            .overlay(configuration.label.foregroundColor(foreground))
            .frame(width: 135, height: 40)
    }
}

extension Color {
    static let tinkPrimary = Color(red: 0.259, green: 0.467, blue: 0.514)
}
