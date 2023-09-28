//
//  WebViewViewControllerSpy.swift
//  Image FeedTests
//
//  Created by Alexandr Seva on 22.09.2023.
//

@testable import Image_Feed
import XCTest

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: Image_Feed.WebViewPresenterProtocol?
    
    var loadRequestCalled: Bool = false
    
    func load(request: URLRequest) {
        loadRequestCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
        
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        
    }
}
