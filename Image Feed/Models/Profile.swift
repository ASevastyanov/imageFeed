//
//  Profile.swift
//  Image Feed
//
//  Created by Alexandr Seva on 16.08.2023.
//

import Foundation

struct Profile {
    let userName: String
    let name: String
    let loginName: String
    let bio: String
    
    init(model: ProfileResult) {
        userName = model.userName
        name = "\(model.firstName ?? "") \(model.lastName ?? "")"
        loginName = "@\(model.userName)"
        bio = model.bio ?? ""
    }
}
