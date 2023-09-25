//
//  ImagesListPresenterSpy.swift
//  Image FeedTests
//
//  Created by Alexandr Seva on 25.09.2023.
//

@testable import Image_Feed
import Foundation

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    var imagesListService = ImagesListService.shared
    var photos: [Photo] = []
    var viewDidLoadCalled: Bool = false
    var likeChangeService: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func getURLForlargeImage(indexPath: IndexPath) -> URL? {
        return URL(string: "Test URL")
    }
    
    func photosCouneter() -> (oldCount: Int, newCount: Int) {
        return (10, 20)
    }
    
    func likeChangeService(_ cell: ImagesListCell, _ indexPath: IndexPath) {
        likeChangeService = true
    }
}
