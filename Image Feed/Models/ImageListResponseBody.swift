//
//  ImageListResponseBody.swift
//  Image Feed
//
//  Created by Alexandr Seva on 05.09.2023.
//

import Foundation

struct ImageListResponseBody: Codable {
    let id: String
    let createdAt: String
    let width, height: Int
    let likedByUser: Bool
    let description: String
    let urls: Urls
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width, height
        case likedByUser = "liked_by_user"
        case description, urls
    }
}

struct Urls: Codable {
    let raw, full, regular, small, thumb: String
}
