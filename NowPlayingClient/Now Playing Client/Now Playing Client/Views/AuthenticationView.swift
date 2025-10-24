//
//  AuthenticationBar.swift
//  Now Playing Client
//
//  Created by Marc Steele on 24/10/2025.
//

import SwiftUI

struct AuthenticationView: View {
    var authenticationService: AuthenticationService = AuthenticationService.getService()
    
    var body: some View {
        HStack {
            AuthenticationButton(authenticationService: authenticationService)
            AuthenticationStatusBanner(authenticationStatus: authenticationService.state)
        }
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
