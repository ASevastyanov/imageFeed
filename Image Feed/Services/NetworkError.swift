import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError
    case urlSessionError
    case urlError
    case urlComponentsError
    case decodeError(Error)
}
