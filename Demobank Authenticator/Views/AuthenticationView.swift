import SwiftUI

struct AuthenticationView: View {

    @StateObject var viewModel = ViewModel()

    var body: some View {
        ZStack {
            BackgroundView().edgesIgnoringSafeArea(.all)

            VStack(spacing: 22) {
                TinkDemoLogo().frame(width: 80, height: 80)
                Text("Tink Demo Bank")
                    .bold()
                    .font(.system(size: 21))
                    .foregroundColor(Color.buttonLabel)
                Text(viewModel.statusText)
                    .font(.system(size: 15))
                    .foregroundColor(Color.buttonLabel)

                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .background))
                        .foregroundColor(.buttonLabel)
                        .padding(.top, 50)
                }
                Spacer()
                if let button = viewModel.primaryButton {
                    Button(action: button.action, label: {
                        Text(button.title)
                            .fontWeight(.bold)
                            .font(.system(size: 15))
                    }).buttonStyle(TinkButtonStyle(foreground: Color.buttonLabel, background: Color.button))
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
            }.padding(.top, 140)
        }.onOpenURL(perform: { url in
            guard url.scheme == "tink-demobank-auth", url.host == "auth", url.pathComponents.first == "/", url.pathComponents.count == 2 else {
                return
            }
            self.viewModel.start(with: url.lastPathComponent)
        })
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AuthenticationView(viewModel: AuthenticationView.ViewModel(statusText: "Test", primaryButton: .init(title: "Title", action: { } ), secondaryButton: .init(title: "Secondary", action: { })))
                .previewDevice("iPhone 12 Pro Max")

            AuthenticationView(viewModel: AuthenticationView.ViewModel(statusText: "Test", primaryButton: .init(title: "Title", action: { } ), secondaryButton: .init(title: "Secondary", action: { })))
                .previewDevice("iPhone 12 mini")

            AuthenticationView()
        }
    }
}
