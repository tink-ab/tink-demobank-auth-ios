import SwiftUI

struct ContentView: View {

    @EnvironmentObject var authenticationController: AuthenticationController

    @State private var isPresentingAuthenticationRequest: Bool = false

    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)

            VStack {
                Image("pfm_illustration").resizable().aspectRatio(contentMode: .fit).edgesIgnoringSafeArea(.top)
                Text("Tink Demobank")

                    .font(.largeTitle)
                    .fontWeight(.medium)
                Text("Waiting for authentication request...").font(.footnote)
                Spacer()

            }
            .blur(radius: self.authenticationController.authenticationTask == nil ? 0 : 3)
            
            if authenticationController.authenticationTask != nil {
                authenticationController.authenticationTask.map { AuthenticationRequestView(authenticationTask: $0) }?.shadow(radius: 5)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(AuthenticationController())
    }
}
