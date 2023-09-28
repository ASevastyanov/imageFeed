//
//  ImagesListViewControllerSpy.swift
//  Image FeedTests
//
//  Created by Alexandr Seva on 25.09.2023.
//

@testable import Image_Feed
import Foundation

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImagesListPresenterProtocol?
    var updateTableViewAnimatedCalled: Bool = false
    var showAlertCalled: Bool = false
    
    func updateTableViewAnimated() {
        updateTableViewAnimatedCalled = true
    }
    
    func showAlertNetworkError() {
        showAlertCalled = true
    }
}
