import SwiftUI

struct AuthenticationRequestView: View {

    @ObservedObject var authenticationTask: AuthenticationTask
    
    var body: some View {
        Group {
            if authenticationTask.isLoading {
                Text("Fetching").font(.largeTitle)
            } else if authenticationTask.errorMessage != nil {
                VStack(spacing: 8) {
                    Text(authenticationTask.errorMessage ?? "An error occurred.")
                    Button("Close") {
                        self.authenticationTask.finish()
                    }
                }
            } else if authenticationTask.completeMessage != nil {
                Text(authenticationTask.completeMessage?.message ?? "")
            } else if authenticationTask.ticket != nil {
                VStack(spacing: 8) {
                    Text(authenticationTask.ticket?.header ?? "").font(.title)
                    Text(authenticationTask.ticket?.message ?? "")
                    HStack {
                        Button(authenticationTask.ticket?.cancelButtonText ?? "") {
                            self.authenticationTask.cancelTicket()
                        }.padding()
                        Button(authenticationTask.ticket?.confirmButtonText ?? "") {
                            self.authenticationTask.confirmTicket()
                        }.padding()
                    }
                }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
        .background(Color.white)
        .cornerRadius(8.0).padding(8)
    }
}

struct AuthenticationRequestView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationRequestView(authenticationTask: AuthenticationTask(ticket: Ticket(header: "Login Attempt", message: "You are attempting to login to Demobank as user abcd.\n\nPressing ‘Confirm’ will send you back to the Tink App", confirmButtonText: "Confirm", cancelButtonText: "Cancel"), errorMessage: nil, isLoading: false, completeMessage: nil))
    }
}
