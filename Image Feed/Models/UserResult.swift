//
//  UserResult.swift
//  Image Feed
//
//  Created by Alexandr Seva on 20.08.2023.
//

import Foundation

struct UserResult: Codable {
    let profileImage: ProfileImage?
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

// MARK: - ProfileImage
struct ProfileImage: Codable {
    let small: String
    let medium: String
}
