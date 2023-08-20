import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    
    func fetchOAuthToken(
        _ code: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        assert(Thread.isMainThread)
        if lastCode == code { return }
        task?.cancel()
        lastCode = code
        
        guard let request = authTokenRequest(code: code) else {
            assertionFailure("\(NetworkError.urlRequestError)")
            return
        }
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self = self else { return }
            self.task = nil
            switch result {
            case .success(let responseBody):
                completion(.success(responseBody.accessToken))
            case .failure(let error):
                completion(.failure(error))
                self.lastCode = nil
            }
        }
        self.task = task
        task.resume()
    }
}

extension OAuth2Service {
    private func authTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: AuthConfig.pathToken) else {
            assertionFailure("\(NetworkError.urlComponentsError)")
            return nil
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: AuthConfig.accessKey),
            URLQueryItem(name: "client_secret", value: AuthConfig.secretKey),
            URLQueryItem(name: "redirect_uri", value: AuthConfig.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: AuthConfig.grantType)
        ]
        guard let url = urlComponents.url else {
            assertionFailure("\(NetworkError.urlError)")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
}
