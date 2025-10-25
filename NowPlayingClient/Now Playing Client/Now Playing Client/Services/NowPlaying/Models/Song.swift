//
//  Song.swift
//  Now Playing Client
//
//  Created by Marc Steele on 25/10/2025.
//

import Foundation

struct NowPlayingDTO: Codable {
    var artist: String
    var title: String
    var year: Int?
}
