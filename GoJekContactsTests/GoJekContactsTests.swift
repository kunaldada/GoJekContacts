//
//  GoJekContactsTests.swift
//  GoJekContactsTests
//
//  Created by ioshellboy on 12/06/19.
//  Copyright © 2019 ioshellboy. All rights reserved.
//

import XCTest
@testable import GoJekContacts

class GoJekContactsTests: XCTestCase {

    var contactListViewModal: ContactListViewModal!
    var addEditContactViewModal: AddEditContactViewModal!
    var mockDataFetcher: MockDataFetcher!
    
    override func setUp() {
        contactListViewModal = ContactListViewModal()
        addEditContactViewModal = AddEditContactViewModal()
        mockDataFetcher = MockDataFetcher()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        contactListViewModal = nil
        addEditContactViewModal = nil
        mockDataFetcher = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testShortContactModalGroupings() {
        let contact1 = ShortContactModal(contactId: nil, firstName: "Abhishek", lastName: nil, profilePic: nil, favorite: nil, url: nil, errors: nil)
        let contact2 = ShortContactModal(contactId: nil, firstName: "Arijit", lastName: nil, profilePic: nil, favorite: nil, url: nil, errors: nil)
        let contact3 = ShortContactModal(contactId: nil, firstName: "Ramesh", lastName: nil, profilePic: nil, favorite: nil, url: nil, errors: nil)
        let contact4 = ShortContactModal(contactId: nil, firstName: "rakesh", lastName: nil, profilePic: nil, favorite: nil, url: nil, errors: nil)
        let contact5 = ShortContactModal(contactId: nil, firstName: "123", lastName: nil, profilePic: nil, favorite: nil, url: nil, errors: nil)
        let contact6 = ShortContactModal(contactId: nil, firstName: "@naiyo", lastName: nil, profilePic: nil, favorite: nil, url: nil, errors: nil)
        
        contactListViewModal?.shortContacts = [contact1, contact3, contact5, contact2, contact4, contact6]
        contactListViewModal?.prepareCellViewModals()
        
        var expectedGrouping: [[ShortContactModal]] = []
        expectedGrouping.append([contact1, contact2])
        expectedGrouping.append([contact4, contact3])
        expectedGrouping.append([contact6, contact5])
        
        let expectedExistingTitles = ["A", "R", "#"]
        
        
        XCTAssertEqual(contactListViewModal.groupedShortContacts[0][0].firstName, expectedGrouping[0][0].firstName, "Wrong grouping computed")
        XCTAssertEqual(contactListViewModal.groupedShortContacts[0][1].firstName, expectedGrouping[0][1].firstName, "Wrong grouping computed")
        XCTAssertEqual(contactListViewModal.groupedShortContacts[1][0].firstName, expectedGrouping[1][0].firstName, "Wrong grouping computed")
        XCTAssertEqual(contactListViewModal.groupedShortContacts[1][1].firstName, expectedGrouping[1][1].firstName, "Wrong grouping computed")
        XCTAssertEqual(contactListViewModal.groupedShortContacts[2][0].firstName, expectedGrouping[2][0].firstName, "Wrong grouping computed")
        XCTAssertEqual(contactListViewModal.groupedShortContacts[2][1].firstName, expectedGrouping[2][1].firstName, "Wrong grouping computed")
        XCTAssertEqual(contactListViewModal.existingTitles, expectedExistingTitles, "Wrong existing titles computed")

    }
    
    func testEditContactFlow() {
        let existingContact: ContactModal = ContactModal(contactId: 1, firstName: "Abhishek", lastName: nil, profilePic: nil, favorite: nil, email: nil, phoneNumber: nil, errors: nil)
        
        var changedInfoValues: [ContactKeys: String] = [:]
        changedInfoValues[ContactKeys.firstName] = "Abhishekk"
        changedInfoValues[ContactKeys.lastName] = "Kumar"
        changedInfoValues[ContactKeys.email] = "abhishek@gmail.com"
        changedInfoValues[ContactKeys.phoneNumber] = "9876543210"
        
        let updatedContact: ContactModal = ContactModal(contactId: 1, firstName: changedInfoValues[ContactKeys.firstName], lastName: changedInfoValues[ContactKeys.lastName] , profilePic: nil, favorite: nil, email: changedInfoValues[ContactKeys.email], phoneNumber: changedInfoValues[ContactKeys.phoneNumber], errors: nil)
        
        mockDataFetcher.expectedDataResponse = (updatedContact, nil)
        
        addEditContactViewModal.detailModal = existingContact
        addEditContactViewModal.dataFetcher = mockDataFetcher
        addEditContactViewModal.changedInfoValues = changedInfoValues
        
        addEditContactViewModal.validationCallBlock = {(syncSuccessfull: Bool, updatedContact: ContactsAddEditDetailModalProtocol?, errorMsg: String?) in
            XCTAssertEqual(syncSuccessfull, true, "Sync was successfull from the server level but the client missed something")
            XCTAssertEqual(updatedContact?.contactIdentifier, existingContact.contactIdentifier, "Sync returned a different id")
        }
        
        addEditContactViewModal.validateAllDataAndSync()
        
        XCTAssertEqual(mockDataFetcher.updatedDataRequestor?.dataRequestType, DataRequestType.put, "Data call for put not going")
        
        let apiFirstNameParam: String? = mockDataFetcher.updatedDataRequestor?.appendedParameters?[ContactKeys.firstName.postingValue] as? String
        XCTAssertEqual(apiFirstNameParam, changedInfoValues[ContactKeys.firstName], "Text Field entry does not matches the paramtere posted to the server")
    }

    func testAddContactFlow() {
        
        var changedInfoValues: [ContactKeys: String] = [:]
        changedInfoValues[ContactKeys.firstName] = "Abhishekk"
        changedInfoValues[ContactKeys.lastName] = "Kumar"
        changedInfoValues[ContactKeys.email] = "abhishek@gmail.com"
        changedInfoValues[ContactKeys.phoneNumber] = "9876543210"
        
        let updatedContact: ContactModal = ContactModal(contactId: 1, firstName: changedInfoValues[ContactKeys.firstName], lastName: changedInfoValues[ContactKeys.lastName] , profilePic: nil, favorite: nil, email: changedInfoValues[ContactKeys.email], phoneNumber: changedInfoValues[ContactKeys.phoneNumber], errors: nil)
        
        mockDataFetcher.expectedDataResponse = (updatedContact, nil)
        
        addEditContactViewModal.dataFetcher = mockDataFetcher
        addEditContactViewModal.changedInfoValues = changedInfoValues
        
        addEditContactViewModal.validationCallBlock = {(syncSuccessfull: Bool, updatedContact: ContactsAddEditDetailModalProtocol?, errorMsg: String?) in
            XCTAssertEqual(syncSuccessfull, true, "Sync was successfull from the server level but the client missed something")
        }
        
        addEditContactViewModal.validateAllDataAndSync()
        
        XCTAssertEqual(mockDataFetcher.updatedDataRequestor?.dataRequestType, DataRequestType.post, "Data call for post not going")
        
        let apiFirstNameParam: String? = mockDataFetcher.updatedDataRequestor?.appendedParameters?[ContactKeys.firstName.postingValue] as? String
        XCTAssertEqual(apiFirstNameParam, changedInfoValues[ContactKeys.firstName], "Text Field entry does not matches the paramtere posted to the server")
        
    }
    
}
