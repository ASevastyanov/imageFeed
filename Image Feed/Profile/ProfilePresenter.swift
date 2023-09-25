//
//  ProfileViewPresenter.swift
//  Image Feed
//
//  Created by Alexandr Seva on 24.09.2023.
//

import Foundation
import WebKit

protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func notificationProfileImage()
    func getURLForAvatar() -> URL?
    func clean()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var  view: ProfileViewControllerProtocol?
    private var profileImageServiceObserver: NSObjectProtocol?
    private let oAuth2TokenStorege = OAuth2ServiceStorage.shared
    private let imagesListService = ImagesListService.shared
    private let profileService = ProfileService.shared
    private let profileImage = ProfileImageService.shared
    
    func viewDidLoad() {
        notificationProfileImage()
        view?.updateProfile(profile: profileService.profile)
    }
    
    func notificationProfileImage() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.view?.updateAvatar()
            }
    }
    
    func getURLForAvatar() -> URL? {
        guard
            let profileImageURL = profileImage.avatarURL,
            let url = URL(string: profileImageURL)
        else { return nil }
        return url
    }
    
    func clean() {
        oAuth2TokenStorege.removeToken()
        imagesListService.deletePhotos()
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}
