import UIKit
import ProgressHUD

//MARK: - UIViewController
final class SplashViewController: UIViewController {
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthentication"
    private let oAuth2Service = OAuth2Service()
    private let oAuth2TokenStorege = OAuth2ServiceStorage()
    private let profileService = ProfileService.shared
    
    override func viewDidAppear(_ animated: Bool) {
        tokenVerification()
    }
    
    private func  switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    
    private func tokenVerification() {
        if let token = oAuth2TokenStorege.token {
            fetchProfile(with: token)
        } else {
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
}

//MARK: - func prepare
extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else { fatalError("Failed to prepare for\(showAuthenticationScreenSegueIdentifier)") }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

//MARK: - AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            UIBlockingProgressHUD.show()
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oAuth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                oAuth2TokenStorege.token = token
                fetchProfile(with: token)
            case .failure:
                // TODO
                break
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    private func fetchProfile(with token: String) {
        UIBlockingProgressHUD.show()
                profileService.fetchProfil(token) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success:
                        UIBlockingProgressHUD.dismiss()
                        switchToTabBarController()
                    case .failure(let error):
                        // TODO
                        break
                        
                    }
                    UIBlockingProgressHUD.dismiss()
                }
    }
}
