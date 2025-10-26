//
//  NowPlayingSettingsView.swift
//  Now Playing Client
//
//  Created by Marc Steele on 24/10/2025.
//

import SwiftUI

struct NowPlayingSettingsView: View {
    @AppStorage(Constants.settingsNowPlayingDomain) private var nowPlayingDomain = "nowplaying.solidradio.co.uk"
    @AppStorage(Constants.settingsNowPlayingStation) private var nowPlayingStation: String = ""
    
    var body: some View {
        Form {
            TextField("Domain", text: $nowPlayingDomain)
            TextField("Station", text: $nowPlayingStation)
        }
        .padding()
    }
}

struct NowPlayingSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NowPlayingSettingsView()
    }
}
