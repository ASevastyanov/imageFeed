import UIKit
import Kingfisher

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func showAlertToLogOut()
    func updateProfile(profile: Profile?)
    func updateAvatar()
}

typealias ProfileViewControllerProtocols = UIViewController & ProfileViewControllerProtocol

//MARK: - UIViewController
final class ProfileViewController: ProfileViewControllerProtocols {
    private var alertPresenter: AlertPresenterProtocol?
    private let gradientLayer = GradientLayer.shared
    var presenter: ProfilePresenterProtocol?
    
    private lazy var profileImageView : UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Photo"))
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameUserLabel : UILabel = {
        let nameUserLabel = UILabel()
        nameUserLabel.text = " "
        nameUserLabel.textColor = .ypWhite
        nameUserLabel.font = .boldSystemFont(ofSize: 23)
        nameUserLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameUserLabel
    }()
    
    private lazy var loginUserLabel : UILabel = {
        let loginUserLabel = UILabel()
        loginUserLabel.text = " "
        loginUserLabel.textColor = .ypGray
        loginUserLabel.font = .systemFont(ofSize: 13)
        loginUserLabel.translatesAutoresizingMaskIntoConstraints = false
        return loginUserLabel
    }()
    
    private lazy var userDescriptionLabel : UILabel = {
        let userDescriptionLabel = UILabel()
        userDescriptionLabel.numberOfLines = 0
        userDescriptionLabel.text = " "
        userDescriptionLabel.textColor = .ypWhite
        userDescriptionLabel.font = .systemFont(ofSize: 13)
        userDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return userDescriptionLabel
    }()
    
    private lazy var logoutButtom : UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(named: "Exit")!,
            target: self,
            action: #selector(self.didTapLogoutButton))
        button.tintColor = .ypRed
        button.accessibilityIdentifier = "logoutButton"
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateProfileAnimation()
        presenter = ProfilePresenter()
        presenter?.view = self
        presenter?.viewDidLoad()
        configViews()
        configConstraints()
        alertPresenter = AlertPresenter(viewControler: self)
    }
    
    // MARK: - Actions
    @objc
    private func didTapLogoutButton() {
        showAlertToLogOut()
    }
    
    //MARK: - Methods
    func configure(_ presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
        self.presenter?.view = self
    }
    
    func updateProfile(profile: Profile?) {
        updateAvatar()
        
        guard let profile = profile else { return }
        nameUserLabel.text = profile.name
        loginUserLabel.text = profile.loginName
        userDescriptionLabel.text = profile.bio
    }
    
    func updateAvatar() {
        let url = presenter?.getURLForAvatar()
        profileImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "Photo")
        )
        gradientLayer.removeFromSuperLayer(views: [profileImageView, nameUserLabel, loginUserLabel, userDescriptionLabel])
    }
    
    func showAlertToLogOut() {
        let alert = AlertModelTwoAction(
            title: "Пока, пока!",
            massage: "Уверены что хотите выйти?",
            buttonText: "Да",
            buttonTextCancel: "Нет",
            completion: { [weak self] in
                guard let self else { return }
                presenter?.clean()
                guard let window = UIApplication.shared.windows.first else {
                    fatalError("invalid configuration")
                }
                window.rootViewController = SplashViewController()
                window.makeKeyAndVisible()
            })
        alertPresenter?.showAlertTwoAction(with: alert)
    }
    
    //MARK: - Private methods
    private func configViews() {
        view.backgroundColor = .ypBlack
        view.addSubview(profileImageView)
        view.addSubview(nameUserLabel)
        view.addSubview(loginUserLabel)
        view.addSubview(userDescriptionLabel)
        view.addSubview(logoutButtom)
    }
    
    private func configConstraints() {
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            nameUserLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            nameUserLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            nameUserLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            loginUserLabel.topAnchor.constraint(equalTo: nameUserLabel.bottomAnchor, constant: 8),
            loginUserLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            loginUserLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            userDescriptionLabel.topAnchor.constraint(equalTo: loginUserLabel.bottomAnchor, constant: 8),
            userDescriptionLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            userDescriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            logoutButtom.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            logoutButtom.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
        ])
    }
    
    private func updateProfileAnimation(){
        gradientLayer.gradientLayer(view: profileImageView, width: 70, height: 70, cornerRadius: 35)
        gradientLayer.gradientLayer(view: nameUserLabel, width: nameUserLabel.intrinsicContentSize.width, height: nameUserLabel.intrinsicContentSize.height, cornerRadius: 10)
        gradientLayer.gradientLayer(view: loginUserLabel, width: loginUserLabel.intrinsicContentSize.width, height: loginUserLabel.intrinsicContentSize.height, cornerRadius: 5)
        gradientLayer.gradientLayer(view: userDescriptionLabel, width: userDescriptionLabel.intrinsicContentSize.width, height: userDescriptionLabel.intrinsicContentSize.height, cornerRadius: 5)
    }
}

