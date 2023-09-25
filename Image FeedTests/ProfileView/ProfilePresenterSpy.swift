//
//  ProfileViewPresenterSpy.swift
//  Image FeedTests
//
//  Created by Alexandr Seva on 24.09.2023.
//

@testable import Image_Feed
import Foundation

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    var notificationProfileCalled: Bool = false
    var cleanSessionCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func notificationProfileImage() {
        notificationProfileCalled = true
    }
    
    func getURLForAvatar() -> URL? {
        return URL(string: "Test URL")
    }
    
    func clean() {
        cleanSessionCalled = true
    }
}
