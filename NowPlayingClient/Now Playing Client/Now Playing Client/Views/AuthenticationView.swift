//
//  AuthenticationBar.swift
//  Now Playing Client
//
//  Created by Marc Steele on 24/10/2025.
//

import SwiftUI

struct AuthenticationView: View {
    @AppStorage(Constants.settingsAuthenticationMethod) private var authenticationMethod: String?
    
    var body: some View {
        HStack {
            switch authenticationMethod {
            case Constants.authenticationMethodAuth0:
                Auth0View()
            default:
                Text("Invalid authentication option!")
            }
        }
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
