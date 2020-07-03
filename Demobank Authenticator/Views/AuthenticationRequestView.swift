import SwiftUI

struct AuthenticationRequestView: View {

    @ObservedObject var authenticationTask: AuthenticationTask
    
    var body: some View {
        Group {
            if authenticationTask.isLoading {
                ActivityIndicator(isAnimating: authenticationTask.isLoading, style: .medium)
            } else if authenticationTask.errorMessage != nil {
                VStack(spacing: 8) {
                    Text("Error").font(.title)
                    Text(authenticationTask.errorMessage ?? "An error occurred.")
                    Button("Close") {
                        self.authenticationTask.finish()
                    }.buttonStyle(TinkButtonStyle()).padding(.top, 8)
                }
            } else if authenticationTask.completeMessage != nil {
                VStack {
                    ActivityIndicator(isAnimating: authenticationTask.completeMessage?.url != nil, style: .medium)
                    Text(authenticationTask.completeMessage?.message ?? "")
                }
            } else if authenticationTask.ticket != nil {
                VStack(alignment: .center, spacing: 8) {
                    Text(authenticationTask.ticket?.header ?? "").font(.title)
                    Text(authenticationTask.ticket?.message ?? "").font(.body).multilineTextAlignment(.center)
                    VStack {
                        Button(authenticationTask.ticket?.confirmButtonText ?? "") {
                            self.authenticationTask.confirmTicket()
                        }.buttonStyle(TinkButtonStyle())
                        Button(authenticationTask.ticket?.cancelButtonText ?? "") {
                            self.authenticationTask.cancelTicket()
                        }.buttonStyle(TinkButtonStyle(foreground: Color.tinkPrimary, background: Color.white))
                    }.offset(y: 8)
                }
            }
        }.foregroundColor(Color.black)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 150)
        .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
        .background(Color.white)
        .cornerRadius(8.0).padding(16)
    }
}

struct AuthenticationRequestView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationRequestView(authenticationTask: AuthenticationTask(
            ticket: Ticket(header: "Login Attempt", message: "You are attempting to login to Demobank as user abcd.\n\nPressing ‘Confirm’ will send you back to the Tink App", confirmButtonText: "Confirm", cancelButtonText: "Cancel"),
            errorMessage: nil,
            isLoading: false,
            completeMessage: nil))
    }
}
