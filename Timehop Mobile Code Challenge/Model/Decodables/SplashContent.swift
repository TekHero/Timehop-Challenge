//
//  SplashContent.swift
//  Timehop Mobile Code Challenge
//
//  Created by Brian Lim on 3/30/21.
//

import Foundation

struct SplashContent: Codable {
    var details: [SplashContentDetail]
    
    enum CodingKeys: String, CodingKey {
        case details = "images"
    }
}

struct SplashContentDetail: Codable {
    var id: Int
    var profileImageURL: String
    var mediaURL: String
    var sourceID: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case profileImageURL = "url"
        case mediaURL = "large_url"
        case sourceID = "source_id"
    }
}
