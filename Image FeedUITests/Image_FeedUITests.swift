//
//  Image_FeedUITests.swift
//  Image FeedUITests
//
//  Created by Alexandr Seva on 26.09.2023.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication()
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testAuth() throws {
        app.buttons["Войти"].tap()
        let webViewsQuery = app.webViews.webViews.webViews
        let webView = webViewsQuery.otherElements["Connect ImageFeed + Unsplash | Unsplash"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText("Enter login") //Для авторизации необходимо ввести логин
        webView.tap()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        passwordTextField.typeText("Enter password") //Для авторизации необходимо ввести пароль
        webView.tap()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        sleep(2)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        cellToLike.buttons["like button off"].tap()
        sleep(1)
        cellToLike.buttons["like button on"].tap()
        sleep(1)
        
        cellToLike.tap()
        sleep(4)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["Backward"]
        navBackButtonWhiteButton.tap()
        
    }
    
    func testProfile() throws {
        sleep(1)
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts["Name Lastname"].exists)//Необходимо указать Имя и Фамилию через пробел как указано в профиле
        XCTAssertTrue(app.staticTexts["@loginName"].exists)//Необходимо указать @логин как указано в профиле
        
        app.buttons["Exit"].tap()
        
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
        sleep(1)
    }
}
