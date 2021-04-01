//
//  SplashVideo.swift
//  Timehop Mobile Code Challenge
//
//  Created by Brian Lim on 3/25/21.
//

import Foundation

struct SplashVideo: Codable {
    var images: [SplashVideoDetail]
}

struct SplashVideoDetail: Codable {
    var id: Int
    var url: String
    var largeURL: String
    var sourceID: Int
    
    enum CodingKeys: String, CodingKey {
        case id, url
        case largeURL = "large_url"
        case sourceID = "source_id"
    }
}
