import UIKit
import ProgressHUD

//MARK: - UIViewController
final class SplashViewController: UIViewController {
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthentication"
    private let oAuth2Service = OAuth2Service()
    private let oAuth2TokenStorege = OAuth2ServiceStorage()
    private let profileService = ProfileService.shared
    private var alertPresenter: AlertPresenterProtocol?
    
    private lazy var screenLogoImage : UIImageView = {
        var imageView = UIImageView()
        imageView = UIImageView(image: UIImage(named: "splash_screen_logo"))
        imageView.contentMode = .scaleAspectFit
        imageView.center = view.center
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter = AlertPresenter(viewControler: self)
        view.backgroundColor = .ypBlack
        view.addSubview(screenLogoImage)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tokenVerification()
    }
    
    private func  switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    
    private func tokenVerification() {
        if let token = oAuth2TokenStorege.getToken() {
            fetchProfile(with: token)
        } else {
            showAuthController()
        }
    }
    
    private func showAlertNetworkError() {
        let alert = AlertModel(
            title: "Что-то пошло не так(",
            massage: "Не удалось войти в систему",
            buttonText: "Ок",
            completion: { [weak self] in
                guard let self else { return }
                tokenVerification()
            })
        alertPresenter?.showAlert(with: alert)
    }
    
    private func showAuthController() {
        let viewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "AuthViewController")
        guard let authViewController = viewController as? AuthViewController else { return }
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true)
    }
}

//MARK: - AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        self.fetchOAuthToken(code)
    }
    
    private func fetchOAuthToken(_ code: String) {
        oAuth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                oAuth2TokenStorege.setToken(token: token)
                fetchProfile(with: token)
            case .failure:
                UIBlockingProgressHUD.dismiss()
                showAlertNetworkError()
                break
            }
        }
    }
    
    private func fetchProfile(with token: String) {
        UIBlockingProgressHUD.show()
        profileService.fetchProfil(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                switchToTabBarController()
            case .failure(_):
                showAlertNetworkError()
                break
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
}
