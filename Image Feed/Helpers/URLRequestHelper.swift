import Foundation

// MARK: - HTTP Request

extension URLRequest {
    static func makeHTTPRequest(
        url: URL,
        httpMethod: String
    ) -> URLRequest {
            var request = URLRequest(url: url)
            request.httpMethod = httpMethod
            return request
        }
   }
