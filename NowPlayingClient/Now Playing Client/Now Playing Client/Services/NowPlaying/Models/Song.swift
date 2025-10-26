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

    enum CodingKeys: String, CodingKey {
        case artist, title, year
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(artist, forKey: .artist)
        try container.encode(title, forKey: .title)
        if let year {
            try container.encode(year, forKey: .year)
        } else {
            try container.encodeNil(forKey: .year)
        }
    }

    init(artist: String, title: String, year: Int?) {
        self.artist = artist
        self.title = title
        self.year = year
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        artist = try container.decode(String.self, forKey: .artist)
        title = try container.decode(String.self, forKey: .title)
        year = try container.decodeIfPresent(Int.self, forKey: .year)
    }
}
