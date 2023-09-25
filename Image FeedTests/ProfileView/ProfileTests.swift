//
//  ProfileViewTests.swift
//  Image FeedTests
//
//  Created by Alexandr Seva on 24.09.2023.
//

@testable import Image_Feed
import XCTest

final class ProfileTest: XCTestCase {
    func testProfileViewControllerCallsViewDidLoad() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.viewDidLoad()
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testNotificationProfileImage() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        presenter.notificationProfileImage()
        
        //then
        XCTAssertTrue(presenter.notificationProfileCalled)
    }
    
    func testProfileUpdateAvatarURL() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        let avatarURL: URL? = URL(string: "Test URL")
        
        //then
        XCTAssertEqual(presenter.getURLForAvatar(), avatarURL)
    }
    
    func testViewControllerCallsCleanCurrentSessionContext() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        presenter.clean()
        
        //then
        XCTAssertTrue(presenter.cleanSessionCalled)
    }
    
    func testshowAlertToLogOut() {
        //given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenter()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        viewController.showAlertToLogOut()
        
        //then
        XCTAssertTrue(viewController.showAlertCalled)
    }
    
    func testUpdateProfile() {
        //given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenter()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        let profileResult = ProfileResult(
            userName: "User_Name",
            firstName: "First_Name",
            lastName: "Last_Name",
            bio: "Description")
        let profile = Profile(model: profileResult)
        
        viewController.updateProfile(profile: profile)
        
        //then
        XCTAssertTrue(viewController.updateProfileCalled)
    }
    
    func testupdateAvatar() {
        //given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenter()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        viewController.updateAvatar()
        
        //then
        XCTAssertTrue(viewController.updateAvatarCalled)
    }
}
