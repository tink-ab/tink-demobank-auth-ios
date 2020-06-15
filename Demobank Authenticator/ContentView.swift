//
//  ContentView.swift
//  Demobank Authenticator
//
//  Created by Pontus Orraryd on 2020-06-15.
//  Copyright © 2020 Pontus Orraryd. All rights reserved.
//

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
