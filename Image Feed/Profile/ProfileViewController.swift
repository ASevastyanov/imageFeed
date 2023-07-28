//
//  ProfileViewController.swift
//  Image Feed
//
//  Created by Alexandr Seva on 13.07.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    private lazy var profileImage = UIImage(named: "Photo")
    
    private lazy var profileImageView : UIImageView = {
        let imageView = UIImageView(image: profileImage)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameUserLabel : UILabel = {
        let nameUserLabel = UILabel()
        nameUserLabel.text = "Екатерина Новикова"
        nameUserLabel.textColor = .ypWhite
        nameUserLabel.font = UIFont.boldSystemFont(ofSize: 23)
        nameUserLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameUserLabel
    }()
    
    private lazy var loginUserLabel : UILabel = {
        let loginUserLabel = UILabel()
        loginUserLabel.text = "@ekaterina_nov"
        loginUserLabel.textColor = .ypGray
        loginUserLabel.font = UIFont.systemFont(ofSize: 13)
        loginUserLabel.translatesAutoresizingMaskIntoConstraints = false
        return loginUserLabel
    }()
    
    private lazy var userDescriptionLabel : UILabel = {
        let userDescriptionLabel = UILabel()
        userDescriptionLabel.numberOfLines = 0
        userDescriptionLabel.text = "Hello, world!"
        userDescriptionLabel.textColor = .ypWhite
        userDescriptionLabel.font = UIFont.systemFont(ofSize: 13)
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
    }
    
    // MARK: - Actions
    @objc
    private func didTapLogoutButton() {}
    
    //MARK: - Methods
    private func configViews() {
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
}

