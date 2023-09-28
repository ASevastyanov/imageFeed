//
//  ImagesListPresenter.swift
//  Image Feed
//
//  Created by Alexandr Seva on 25.09.2023.
//

import Foundation

protocol ImagesListPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    var imagesListService: ImagesListService { get set }
    var photos: [Photo] { get set }
    func viewDidLoad()
    func getURLForlargeImage(indexPath: IndexPath) -> URL?
    func photosCouneter() -> (oldCount: Int, newCount: Int)
    func likeChangeService(_ cell: ImagesListCell, _ indexPath: IndexPath)
}

//MARK: - ImagesListPresenter
final class ImagesListPresenter: ImagesListPresenterProtocol {
    private var profileImageServiceObserver: NSObjectProtocol?
    private var gradientLayer = GradientLayer.shared
    var view: ImagesListViewControllerProtocol?
    var imagesListService = ImagesListService.shared
    var photos: [Photo] = []
    
    // MARK: - Lifecycle
    func viewDidLoad() {
        imagesListService.fetchPhotosNextPage()
        notificationImagesList()
    }
    
    //MARK: - Methods
    func getURLForlargeImage(indexPath: IndexPath) -> URL? {
        let photo = photos[indexPath.row]
        let fullImageUrl = URL(string: photo.largeImageURL)
        return fullImageUrl
    }
    
    func photosCouneter() -> (oldCount: Int, newCount: Int) {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        return (oldCount, newCount)
    }
    
    func notificationImagesList() {
        NotificationCenter.default
            .addObserver(forName: ImagesListService.didChangeNotification,
                         object: imagesListService,
                         queue: .main) { [weak self] _ in
                guard let self = self else { return }
                self.view?.updateTableViewAnimated()
            }
    }
    
    func likeChangeService(_ cell: ImagesListCell,_ indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        gradientLayer.animateLikeButton(cell.likeButton)
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: photo.isLiked) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.photos = self.imagesListService.photos
                cell.setIsLiked(!photo.isLiked)
            case .failure(let error):
                view?.showAlertNetworkError()
                assertionFailure("Error to change like info \(error)")
            }
            gradientLayer.stopLikeButton(cell, photo: photo)
            UIBlockingProgressHUD.dismiss()
        }
    }
}
