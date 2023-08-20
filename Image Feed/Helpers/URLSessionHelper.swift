import Foundation

// MARK: - Network Connection

extension URLSession {
    func objectTask<DecodingType: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<DecodingType, Error>) -> Void
    ) -> URLSessionTask {
        let task = dataTask(with: request) { data, response, error in
            if let error {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.urlSessionError))
                }
            }
            if let response = response as? HTTPURLResponse {
                if !(200..<300 ~= response.statusCode) {
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.httpStatusCode(response.statusCode)))
                    }
                }
            }
            if let data {
                
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(DecodingType.self, from: data)
                    
                    DispatchQueue.main.async {
                        completion(.success(result))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.decodeError(error)))
                    }
                }
            }
        }
        return task
    }
}


