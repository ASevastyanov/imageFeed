//
//  Photo.swift
//  Image Feed
//
//  Created by Alexandr Seva on 05.09.2023.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
    
    init (model: ImageListResponseBody, dateFormatter: ISO8601DateFormatter) {
        id = model.id
        size = CGSize(width: model.width, height: model.width)
        createdAt = dateFormatter.date(from: model.createdAt)
        welcomeDescription = model.description
        thumbImageURL = model.urls.thumb
        largeImageURL = model.urls.raw
        isLiked = model.likedByUser
    }
}
