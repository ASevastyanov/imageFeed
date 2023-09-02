//
//  AlertPresenterProtocol.swift
//  Image Feed
//
//  Created by Alexandr Seva on 23.08.2023.
//

import Foundation

protocol AlertPresenterProtocol: AnyObject {
    func showAlert(with model: AlertModel)
}
