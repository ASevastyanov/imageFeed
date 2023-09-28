//
//  ProfileViewControllerSpy.swift
//  Image FeedTests
//
//  Created by Alexandr Seva on 24.09.2023.
//

@testable import Image_Feed
import Foundation

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?
    var showAlertCalled: Bool = false
    var updateProfileCalled: Bool = false
    var updateAvatarCalled: Bool = false
    
    func showAlertToLogOut() {
        showAlertCalled = true
    }
    
    func updateProfile(profile: Profile?) {
        updateProfileCalled = true
    }
    
    func updateAvatar() {
        updateAvatarCalled = true
    }
}
