//
//  ProfileViewController.swift
//  Image Feed
//
//  Created by Alexandr Seva on 13.07.2023.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet private var photoUserImages: UIImageView!
    @IBOutlet private var nameUserLabel: UILabel!
    @IBOutlet private var loginUserLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    
    @IBOutlet private var logoutButtom: UIButton!
    
    @IBAction private func didTapLogoutButton() {
    }
}
