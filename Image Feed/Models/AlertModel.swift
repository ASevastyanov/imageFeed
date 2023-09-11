//
//  AlertModel.swift
//  Image Feed
//
//  Created by Alexandr Seva on 23.08.2023.
//

import Foundation

struct AlertModel {
    let title: String
    let massage: String
    let buttonText: String
    let completion: (() -> Void)?
}

struct AlertModelTwoAction {
    let title: String
    let massage: String
    let buttonText: String
    let buttonTextCancel: String
    let completion: (() -> Void)?
}
