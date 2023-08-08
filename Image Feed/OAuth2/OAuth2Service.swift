import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    private let urlSession = URLSession.shared
    
    func fetchOAuthToken(
        _ code: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        let request = try? authTokenRequest(code: code)
        guard let request = request else { return }
        let task = object(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let body):
                let authToken = body.accessToken
                completion(.success(authToken))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
extension OAuth2Service {
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        return urlSession.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<OAuthTokenResponseBody, Error> in
                Result { try decoder.decode(OAuthTokenResponseBody.self, from: data) }
            }
            completion(response)
        }
    }
    
    private func authTokenRequest(code: String) throws -> URLRequest {
        guard var urlComponents = URLComponents(string: AuthCinfig.pathToken) else {
            throw NetworkError.urlComponentsError
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: AuthCinfig.accessKey),
            URLQueryItem(name: "client_secret", value: AuthCinfig.secretKey),
            URLQueryItem(name: "redirect_uri", value: AuthCinfig.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: AuthCinfig.grantType)
        ]
        guard let url = urlComponents.url else { throw NetworkError.urlError}
        return URLRequest.makeHTTPRequest(url: url, httpMethod: "POST")
    }
}
