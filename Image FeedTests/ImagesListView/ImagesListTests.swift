//
//  ImagesListTests.swift
//  Image FeedTests
//
//  Created by Alexandr Seva on 25.09.2023.
//

@testable import Image_Feed
import XCTest

let indexPath = IndexPath()
let dateFormatter = ISO8601DateFormatter()
let photoResult = ImageListResponseBody(
    id: "test",
    createdAt: "2022-10-12T01:11:34",
    width: 100,
    height: 100,
    likedByUser: true,
    description: nil,
    urls: Urls(
        raw: "",
        full: "",
        regular: "",
        small: "",
        thumb: ""))
let photos = Photo(model: photoResult, dateFormatter: dateFormatter)

final class ImagesListTests: XCTestCase {
    func testImagesListViewControllerCallsViewDidLoad() {
        //given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.viewDidLoad()
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testgetURLForlargeImage() {
        //given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        let urllargeImage: URL? = URL(string: "Test URL")
        
        //then
        XCTAssertEqual(presenter.getURLForlargeImage(indexPath: indexPath), urllargeImage)
    }
    
    func testLikeChangeService() {
        //given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        presenter.likeChangeService(ImagesListCell(), indexPath)
        
        //then
        XCTAssertTrue(presenter.likeChangeService)
    }
    
    func testImagesListPhotos() {
        //given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        presenter.photos.append(photos)
        
        //then
        XCTAssertEqual(presenter.photos.count, 1)
     }
    
    func testUpdateTableViewAnimated() {
        //given
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenter()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        viewController.updateTableViewAnimated()
        
        //then
        XCTAssertTrue(viewController.updateTableViewAnimatedCalled)
    }
    
    func testShowAlertNetworkError() {
        //given
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenter()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        viewController.showAlertNetworkError()
        
        //then
        XCTAssertTrue(viewController.showAlertCalled)
    }

}
