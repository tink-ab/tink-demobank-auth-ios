import SwiftUI

struct AuthenticationView: View {

    @StateObject var viewModel = ViewModel()

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 22) {
                HeaderView(color: viewModel.color, text: viewModel.statusText)
                    .frame(maxWidth: .infinity, idealHeight: geometry.size.height * 0.70, maxHeight: geometry.size.height * 0.70)
                if viewModel.isLoading {
                    TinkActivityIndicator(isLoading: true).frame(width: 40, height: 40)
                        .accentColor(.buttonLabel)
                        .padding(.top, 50)
                }
                Spacer()
                if let button = viewModel.primaryButton {
                    Button(action: button.action, label: {
                        Text(button.title)
                            .fontWeight(.bold)
                            .font(.system(size: 15))
                    })
                        .buttonStyle(TinkButtonStyle(foreground: Color.buttonLabel, background: Color.button))
                }
                if let button = viewModel.secondaryButton {
                    Button(action: button.action, label: {
                        Text(button.title)
                            .fontWeight(.bold)
                            .font(.system(size: 15))
                    })
                        .foregroundColor(.button)
                        .padding()
                }
            }
                .overlay(
                    Image("tink").renderingMode(.template).foregroundColor(.background).padding([.trailing, .top], 20), alignment: .topTrailing)
                .onOpenURL(perform: { url in
                    guard url.scheme == "tink-demobank-auth", url.host == "auth", url.pathComponents.first == "/", url.pathComponents.count == 2 else {
                        return
                    }
                    self.viewModel.start(with: url.lastPathComponent)
                })
            .background(Color.background.edgesIgnoringSafeArea(.all))
        }
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AuthenticationView(viewModel: AuthenticationView.ViewModel(statusText: "You are attempting to login to Demobank as user u08527362.", primaryButton: .init(title: "Title", action: { } ), secondaryButton: .init(title: "Secondary", action: { })))
                .previewDevice("iPhone 12 Pro Max")

            AuthenticationView(viewModel: AuthenticationView.ViewModel(statusText: "This is an example status text.", primaryButton: .init(title: "Title", action: { } ), secondaryButton: .init(title: "Secondary", action: { })))
                .previewDevice("iPod touch (7th generation)")

            AuthenticationView(viewModel: AuthenticationView.ViewModel(statusText: "Error.", primaryButton: nil, secondaryButton: nil, color: .leftToSpend))
                .previewDevice("iPhone 12 mini")

            AuthenticationView()
                .previewDevice("iPod touch (7th generation)")
        }
    }
}
