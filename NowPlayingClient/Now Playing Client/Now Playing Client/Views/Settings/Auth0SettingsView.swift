//
//  Auth0SettingsView.swift
//  Now Playing Client
//
//  Created by Marc Steele on 24/10/2025.
//

import SwiftUI

struct Auth0SettingsView: View {
    @AppStorage(Constants.settingsAuth0Domain) private var auth0Domain = "<undefined>.auth0.com"
    @AppStorage(Constants.settingsAuth0ClientId) private var auth0ClientId = ""
    
    var body: some View {
        Form {
            TextField("Auth0 Domain", text: $auth0Domain)
            TextField("Auth0 Client ID", text: $auth0ClientId)
        }
        .padding()
    }
}

struct Auth0SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Auth0SettingsView()
    }
}
