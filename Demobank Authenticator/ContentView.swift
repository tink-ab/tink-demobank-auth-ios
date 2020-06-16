import SwiftUI

struct ContentView: View {

    @EnvironmentObject var authenticationController: AuthenticationController

    var body: some View {
        ZStack {
            Text("Demobank").blur(radius: self.authenticationController.authenticationTask == nil ? 0 : 3)
            authenticationController.authenticationTask.map { AuthenticationRequestView(authenticationTask: $0) }
        }.onAppear {
            self.authenticationController.startAuthenticationFlow(with: "1234")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
