//
//  ContentView.swift
//  Now Playing Client
//
//  Created by Marc Steele on 24/10/2025.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var nowPlayingService = NowPlayingService.shared
    
    var body: some View {
        Form {
            AuthenticationView()
            FileWatchView()
            NowPlayingView()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
