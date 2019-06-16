//
//  GoJekContactsUITests.swift
//  GoJekContactsUITests
//
//  Created by ioshellboy on 12/06/19.
//  Copyright © 2019 ioshellboy. All rights reserved.
//

import XCTest

class GoJekContactsUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        
        let tableIndexElement = XCUIApplication().tables.otherElements["table index"]
        tableIndexElement.tap()
//        tableIndexElement.tap()
        
//        let app = XCUIApplication()
//        let tablesQuery = app.tables
//        tablesQuery.staticTexts["aaaaaaa1 babba"].swipeUp()
//        app.otherElements.containing(.navigationBar, identifier:"Contact").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .table).element.swipeUp()
//
//        let contactNavigationBar = app.navigationBars["Contact"]
//        contactNavigationBar.buttons["Contact"].tap()
//        tablesQuery.staticTexts["aaaaaaaaaaaa aaaaaaaaaaa"].tap()
//        contactNavigationBar.buttons["Edit"].tap()
//        tablesQuery.cells.containing(.staticText, identifier:"First Name").children(matching: .textField).element.tap()
//        app.navigationBars["GoJekContacts.AddEditContactView"].buttons["Cancel"].tap()
//        tablesQuery/*@START_MENU_TOKEN@*/.buttons["favourite button"]/*[[".cells.buttons[\"favourite button\"]",".buttons[\"favourite button\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
                    // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery.staticTexts["aaaaaaaaaaaa aaaaaaaaaaa"].tap()
        app.navigationBars["Contact"].buttons["Edit"].tap()
        app.tables.cells.containing(.staticText, identifier:"First Name").children(matching: .textField).element.tap()
        
    }

}
