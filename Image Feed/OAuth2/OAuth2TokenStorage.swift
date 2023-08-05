import Foundation

final class OAuth2ServiceStorage {
    static let shared = OAuth2ServiceStorage()
    private var userDefaults = UserDefaults.standard
    
    
    var token: String? {
        get {
            userDefaults.string(forKey: "Auth token")
        }
        set {
            userDefaults.set(newValue, forKey: "Auth token")
        }
    }
}
