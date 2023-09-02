import Foundation
import SwiftKeychainWrapper

final class OAuth2ServiceStorage {
    static let shared = OAuth2ServiceStorage()
    private let keychain = KeychainWrapper.standard
    
    func setToken(token: String) {
        let isSuccess = keychain.set(token, forKey: "Auth token")
        guard isSuccess else { return }
    }
    
    func getToken() -> String? {
        return keychain.string(forKey: "Auth token")
    }
    
    func removeToken() {
        keychain.remove(forKey: "Auth token")
    }
}
