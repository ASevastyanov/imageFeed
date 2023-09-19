//
//  ProfileService.swift
//  Image Feed
//
//  Created by Alexandr Seva on 14.08.2023.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    private let profileImageService = ProfileImageService.shared
    private(set) var profile: Profile?
    
    private init() {}
    
    func fetchProfil(
        _ bearerToken: String,
        completion: @escaping (Result<Profile, Error>) -> Void
    ) {
        assert(Thread.isMainThread)
        task?.cancel()
        guard var request = URLRequest.makeHTTPRequest(path: "/me", httpMethod: "GET") else {
            completion(.failure(NetworkError.urlRequestError))
            return
        }
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let profileResult):
                self.profile = Profile(model: profileResult)
                guard let profileResponse = self.profile else { return }
                profileImageService.fetchProfileImageURL(bearerToken: bearerToken, username: profileResult.userName) { _ in }
                completion(.success(profileResponse))
            case .failure(let error):
                completion(.failure(error))
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
}
