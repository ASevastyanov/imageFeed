//
//  ImagesListService.swift
//  Image Feed
//
//  Created by Alexandr Seva on 05.09.2023.
//

import Foundation

//MARK: - fetchPhotosNextPage
final class ImagesListService {
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    static let shared = ImagesListService()
    private let oAuth2TokenStorege = OAuth2ServiceStorage()
    private var task: URLSessionTask?
    private let dateFormatter = ISO8601DateFormatter()
    private let urlSession = URLSession.shared
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    
    private init() {}
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        if task != nil { return }
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        guard let request = requestImageList(page: nextPage) else {
            assertionFailure("\(NetworkError.urlRequestError)")
            return
        }
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[ImageListResponseBody], Error>) in
            guard let self = self else { return }
            assert(Thread.isMainThread)
            switch result {
            case .success(let photoResult):
                self.lastLoadedPage = nextPage
                let newPhotos = photoResult.map { Photo(model: $0, dateFormatter: self.dateFormatter) }
                self.photos.append(contentsOf: newPhotos)
                NotificationCenter.default
                    .post(name: ImagesListService.didChangeNotification,
                          object: self,
                          userInfo: ["Photos": self.photos])
            case .failure(let error):
                assertionFailure("\(error)")
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
}

//MARK: - requestImageList
extension ImagesListService {
    private func requestImageList(page: Int) -> URLRequest? {
        guard var urlComponents = URLComponents(string: AuthConfig.defaultBaseURL) else {
            assertionFailure("\(NetworkError.urlComponentsError)")
            return nil
        }
        urlComponents.path = "/photos"
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "10")
        ]
        guard let url = urlComponents.url else {
            assertionFailure("\(NetworkError.urlError)")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        guard let bearerToken = oAuth2TokenStorege.getToken() else { return nil }
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        return request
    }
}

//MARK: - isLiked
extension ImagesListService {
    func changeLike(
        photoId: String,
        isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void
    ) {
        assert(Thread.isMainThread)
        task?.cancel()
        guard let request = requestLiked(isLike: isLike, photoId: photoId) else {
            completion(.failure(NetworkError.urlRequestError))
            return
        }
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<LikePhotoResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let likedResults):
                changeInfoLike(photoId: likedResults.photo.id)
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
}

//MARK: - requestLiked
extension ImagesListService {
    func requestLiked(isLike: Bool, photoId: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: AuthConfig.defaultBaseURL) else {
            assertionFailure("\(NetworkError.urlComponentsError)")
            return nil
        }
        urlComponents.path = "/photos/\(photoId)/like"
        guard let url = urlComponents.url else {
            assertionFailure("\(NetworkError.urlError)")
            return nil
        }
        var request = URLRequest(url: url)
        isLike ? (request.httpMethod = "DELETE") : (request.httpMethod = "POST")
        guard let bearerToken = oAuth2TokenStorege.getToken() else { return nil }
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func changeInfoLike(photoId: String) {
        if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
            let photo = self.photos[index]
            let photoResult = ImageListResponseBody(
                id: photo.id,
                createdAt: photo.createdAt.flatMap { dateFormatter.string(from: $0) },
                width: Int(photo.size.width),
                height: Int(photo.size.height),
                likedByUser: !photo.isLiked,
                description: photo.welcomeDescription,
                urls: Urls(
                    raw: photo.largeImageURL,
                    full: "",
                    regular: "",
                    small: photo.thumbImageURL,
                    thumb: ""
                ))
            let newPhoto = Photo(model: photoResult, dateFormatter: self.dateFormatter)
            self.photos[index] = newPhoto
        }
    }
}

//MARK: - Delete array "Photo" to exit a profile
extension ImagesListService {
    func deletePhotos() {
        photos = []
    }
}
