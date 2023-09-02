//
//  ProfileImageService.swift
//  Image Feed
//
//  Created by Alexandr Seva on 20.08.2023.
//

import Foundation

final class ProfileImageService {
    static let didChangeNotification = Notification.Name(rawValue: "ProfilImageProviderDidChange")
    static let shard = ProfileImageService()
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    private (set) var avatarURL: String?
    
    private init() {}
    
    func fetchProfileImageURL(
        bearerToken: String,
        username: String,
        _ completion: @escaping (Result<String, Error>) -> Void
    ) {
        assert(Thread.isMainThread)
        task?.cancel()
        guard var request = URLRequest.makeHTTPRequest(path: "/users/\(username)", httpMethod: "GET") else {
            completion(.failure(NetworkError.urlRequestError))
            return
        }
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let userResult):
                guard let photoProfile = userResult.profileImage?.small else { return }
                self.avatarURL = photoProfile
                completion(.success(avatarURL!))
                NotificationCenter.default
                    .post(name: ProfileImageService.didChangeNotification,
                          object: self,
                          userInfo: ["URL": avatarURL!])
            case .failure(let error):
                completion(.failure(error))
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
}
