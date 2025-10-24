//
//  SettingsView.swift
//  Now Playing Client
//
//  Created by Marc Steele on 24/10/2025.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        TabView {
            Tab("Authentication", systemImage: "key.shield") {
                Auth0SettingsView()
            }
            Tab("File Watch", systemImage: "binoculars") {
                FileWatchSettingsView()
            }
        }
        .scenePadding()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
