//
//  NowPlayingView.swift
//  Now Playing Client
//
//  Created by Marc Steele on 25/10/2025.
//

import SwiftUI

struct NowPlayingView: View {
    @ObservedObject var nowPlayingService = NowPlayingService.shared
    
    var body: some View {
        Form {
            TextField("Artist", text: .constant(nowPlayingService.nowPlaying?.artist ?? ""))
            TextField("Title", text: .constant(nowPlayingService.nowPlaying?.title ?? ""))
            TextField("Year", text: .constant("\(nowPlayingService.nowPlaying?.year!, default: "")"))
        }
        .padding()
    }
}

struct NowPlayingView_Previews: PreviewProvider {
    static var previews: some View {
        NowPlayingView()
    }
}
