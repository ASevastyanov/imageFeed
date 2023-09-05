import Foundation
import SwiftKeychainWrapper

final class OAuth2ServiceStorage {
    static let shared = OAuth2ServiceStorage()
    private let keychain = KeychainWrapper.standard
    
    private var authToken = "Auth token"
    
    func setToken(token: String) {
        let isSuccess = keychain.set(token, forKey: authToken)
        guard isSuccess else { return }
    }
    
    func getToken() -> String? {
        return keychain.string(forKey: authToken)
    }
    
    func removeToken() {
        keychain.removeObject(forKey: authToken)
    }
}
