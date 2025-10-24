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
            Tab("Now Playing", systemImage: "radio") {
                NowPlayingSettingsView()
            }
            Tab("Authentication", systemImage: "key.shield") {
                AuthenticationSettingsView()
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
