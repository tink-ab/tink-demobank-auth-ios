import SwiftUI

struct ContentView: View {

    @EnvironmentObject var authenticationController: AuthenticationController

    var body: some View {
        Text(authenticationController.errorMessage ?? "")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
