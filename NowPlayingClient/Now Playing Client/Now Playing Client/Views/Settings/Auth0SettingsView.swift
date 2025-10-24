//
//  Auth0SettingsView.swift
//  Now Playing Client
//
//  Created by Marc Steele on 24/10/2025.
//

import SwiftUI

struct Auth0SettingsView: View {
    @AppStorage(Constants.settingsAuth0Domain) private var auth0Domain = "<undefined>.auth0.com"
    
    var body: some View {
        Form {
            TextField("Auth0 Domain", text: $auth0Domain)
        }
        .padding()
    }
}

struct Auth0SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Auth0SettingsView()
    }
}
