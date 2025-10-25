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
            TextField("Year", text: .constant(displayYear))
        }
        .padding()
    }
    
    private var displayYear: String {
        if nowPlayingService.nowPlaying?.year == nil {
            return ""
        }
        return "\(nowPlayingService.nowPlaying?.year!)"
    }
}

struct NowPlayingView_Previews: PreviewProvider {
    static var previews: some View {
        NowPlayingView()
    }
}
