import Foundation

// MARK: - HTTP Request

extension URLRequest {
    static func makeHTTPRequest (
    path: String,
    httpMethod: String,
    baseURL: URL = defaultBaseURL
    ) -> URLRequest {
        var requst = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        requst.httpMethod = httpMethod
        return requst
    }
}
