import SwiftUI

struct AuthenticationRequestView: View {

    @ObservedObject var authenticationTask: AuthenticationTask
    
    var body: some View {
        VStack {
            Group {
                if authenticationTask.isLoading {
                    Text("Fetching").font(.largeTitle)
                } else if authenticationTask.errorMessage != nil {
                    VStack(spacing: 8) {
                        Text(authenticationTask.errorMessage ?? "")
                        Button.init("Close") {
                            self.authenticationTask.finish()
                        }
                    }
                } else if authenticationTask.ticket != nil {
                    VStack {
                        Text(authenticationTask.ticket?.header ?? "")
                        Text(authenticationTask.ticket?.message ?? "")
                        HStack {
                            Button(authenticationTask.ticket?.cancelButtonText ?? "") {
                                self.authenticationTask.cancelTicket()
                            }
                            Button(authenticationTask.ticket?.confirmButtonText ?? "") {
                                self.authenticationTask.confirmTicket()
                            }
                        }
                    }
                } else if authenticationTask.completeMessage != nil {
                    Text(authenticationTask.completeMessage?.message ?? "")
                }
            }
        }//.frame(minWidth: 0, maxWidth: .infinity)
            .padding(EdgeInsets(top: 10, leading: 30, bottom: 10, trailing: 30))
            .background(Color.white)
            .cornerRadius(8.0)
    }
}

struct AuthenticationRequestView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationRequestView(authenticationTask: AuthenticationTask(ticket: nil, errorMessage: "Something went wrong", isLoading: true, completeMessage: nil))
    }
}
