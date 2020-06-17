import SwiftUI

struct ContentView: View {

    @EnvironmentObject var authenticationController: AuthenticationController

    var body: some View {
        ZStack {
            Color.gray.edgesIgnoringSafeArea(.all)
            VStack {
                Text("Tink Demobank")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                Text("Waiting for authentication request...").font(.footnote)

            }.blur(radius: self.authenticationController.authenticationTask == nil ? 0 : 3)

            if authenticationController.authenticationTask != nil {
                authenticationController.authenticationTask.map { AuthenticationRequestView(authenticationTask: $0) }.transition(.scale)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
