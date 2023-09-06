//
//  ImagesListService.swift
//  Image Feed
//
//  Created by Alexandr Seva on 05.09.2023.
//

import Foundation

final class ImagesListService {
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    static let shard = ImagesListService()
    private let oAuth2TokenStorege = OAuth2ServiceStorage()
    private var task: URLSessionTask?
    private let dateFormatter = ISO8601DateFormatter()
    private let urlSession = URLSession.shared
    private (set) var photos: [Photo] = []
    private var lastloadedPage: Int?
    
    private init() {}
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        task?.cancel()
        let nextPage = lastloadedPage == nil ? 1 : lastloadedPage! + 1
        
        guard let request = requestImageList(page: nextPage) else {
            assertionFailure("\(NetworkError.urlRequestError)")
            return
        }
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[ImageListResponseBody], Error>) in
            guard let self = self else { return }
            assert(Thread.isMainThread)
            switch result {
            case .success(let photoResults):
                self.lastloadedPage = nextPage
                let newPhotos = photoResults.map { Photo(model: $0, dateFormatter: self.dateFormatter) }
                self.photos.append(contentsOf: newPhotos)
                print(photos)
                
                NotificationCenter.default
                    .post(name: ImagesListService.didChangeNotification,
                          object: self,
                          userInfo: ["Photos": self .photos])
            case .failure(let error):
                assertionFailure("\(error)")
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
}

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
