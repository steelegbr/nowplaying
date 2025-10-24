//
//  AuthenticationSettingsView.swift
//  Now Playing Client
//
//  Created by Marc Steele on 24/10/2025.
//

import SwiftUI

struct AuthenticationSettingsView: View {
    @AppStorage(Constants.settingsAuthenticationMethod) private var authenticationMethod: String?
    
    var body: some View {
        VStack {
            AuthenticationMethodPicker(selected: $authenticationMethod)
            switch authenticationMethod {
                case Constants.authenticationMethodAuth0:
                    Auth0SettingsView()
                default:
                Text("Please select an authentication method.").padding()
            }
        }
        .padding()
    }
}

struct AuthenticationSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationSettingsView()
    }
}
