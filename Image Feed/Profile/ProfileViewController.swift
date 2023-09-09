import UIKit
import Kingfisher

//MARK: - UIViewController
final class ProfileViewController: UIViewController {
    private let profileService = ProfileService.shared
    private let profileImage = ProfileImageService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
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
        configViews()
        configConstraints()
        updateLabel()
        notificationProfileImage()
        updateAvatar()
    }
    
    // MARK: - Actions
    @objc
    private func didTapLogoutButton() {}
    
    //MARK: - Methods
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
    
    private func updateLabel() {
        guard let profile = profileService.profile else { return }
        nameUserLabel.text = profile.name
        loginUserLabel.text = profile.loginName
        userDescriptionLabel.text = profile.bio
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = profileImage.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        profileImageView.kf.setImage(with: url,
                                     placeholder: UIImage(named: "Photo")
        )
    }
    
    private func notificationProfileImage() {
        profileImageServiceObserver = NotificationCenter.default
                    .addObserver(
                        forName: ProfileImageService.didChangeNotification,
                        object: nil,
                        queue: .main
                    ) { [weak self] _ in
                        guard let self = self else { return }
                        self.updateAvatar()
                    }
    }
}

