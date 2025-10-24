//
//  Auth0View.swift
//  Now Playing Client
//
//  Created by Marc Steele on 24/10/2025.
//

import SwiftUI

struct Auth0View: View {
    @ObservedObject var auth0Service = Auth0AuthenticationService.shared
    
    var body: some View {
        HStack {
            Auth0AuthenticationButton(auth0Service: auth0Service)
            AuthenticationStatusBanner(authenticationStatus: auth0Service.state)
        }
    }
}

struct Auth0View_Previews: PreviewProvider {
    static var previews: some View {
        Auth0View()
    }
}
