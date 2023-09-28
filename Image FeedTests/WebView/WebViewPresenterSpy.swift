//
//  WebViewPresenterSpy.swift
//  Image FeedTests
//
//  Created by Alexandr Seva on 22.09.2023.
//

@testable import Image_Feed
import XCTest

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        
    }
    
    func code(from url: URL) -> String? {
        return nil
    }
}
