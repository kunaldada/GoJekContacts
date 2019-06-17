//
//  GoJekContactsFavoriteTests.swift
//  GoJekContactsFavoriteTests
//
//  Created by ioshellboy on 17/06/19.
//  Copyright © 2019 ioshellboy. All rights reserved.
//

import XCTest
@testable import GoJekContacts

class GoJekContactsFavoriteTests: XCTestCase {

//    var contactListViewController: ContactListViewController!
    var contactDetailViewController: ContactDetailViewController!
    var testContact: ContactModal!
    var contactListViewModal: ContactListViewModal!
    var mockDataFetcher: MockDataFetcher!
    var addEditViewController: AddEditContactViewController!
    
    override func setUp() {
        mockDataFetcher = MockDataFetcher()
        testContact = ContactModal(contactId: 1, firstName: "Go", lastName: "Jek", profilePic: nil, favorite: false, email: "ab@go.jek", phoneNumber: "9876543210", errors: nil)
        contactDetailViewController = ContactDetailViewController(detailModal: testContact, dataFetcher: mockDataFetcher)
        contactListViewModal = ContactListViewModal()
        addEditViewController = AddEditContactViewController(addEditModal: testContact)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        testContact = nil
        contactDetailViewController = nil
        contactListViewModal = nil
        mockDataFetcher = nil
        addEditViewController = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


    
    func testFavorite() {
        //preparing home view modal
        contactListViewModal.shortContacts = [testContact]
        contactListViewModal.prepareCellViewModals()

        //testing favorite api and its reflection from detail page to home page
        let updatedContact: ContactModal = ContactModal(contactId: testContact.contactId, firstName: testContact.firstName, lastName: testContact.lastName, profilePic: testContact.profilePic, favorite: !(testContact.favorite ?? true), email: testContact.email, phoneNumber: testContact.phoneNumber, errors: nil)
        
        mockDataFetcher.expectedDataResponse = (updatedContact, nil)
        let navigationController = UINavigationController(rootViewController: contactDetailViewController)
        
        UIApplication.shared.keyWindow!.rootViewController = navigationController
        
        let _ = navigationController.view
        let _ = contactDetailViewController.view
        
        contactDetailViewController.contactModalUpdatedBlock = {[weak self](updatedContactsDetailModal: ContactsDetailModalProtocol?) in
            self?.contactListViewModal.updateContact(existingIndexPath: IndexPath(row: 0, section: 0), newContact: updatedContactsDetailModal)
        }
        
        
        (contactDetailViewController.viewModal as? ContactDetailViewModal)?.userSelectedActionFromProfile(actionType: .favorite)
        
        XCTAssertEqual(contactListViewModal.cellViewModals?[0][0].shortContact?.firstName, updatedContact.firstName, "Wrong data reflected on home from after fav action take from detail page")
        let updatedFavStatusOnHome = contactListViewModal.cellViewModals?[0][0].shortContact?.favoriteStatus
        XCTAssertEqual(updatedFavStatusOnHome, updatedContact.favorite, "Wrong fav status reflected on home from after fav action take from detail page")
    }

    func testEditDetailsReflectionOnHomeAndDetailScreen() {
        //preparing home view modal
        contactListViewModal.shortContacts = [testContact]
        contactListViewModal.prepareCellViewModals()
        
        //testing favorite api and its reflection from detail page to home page
        let updatedContact: ContactModal = ContactModal(contactId: testContact.contactId, firstName: "Come Back", lastName: testContact.lastName, profilePic: testContact.profilePic, favorite: testContact.favorite, email: testContact.email, phoneNumber: testContact.phoneNumber, errors: nil)
        
        mockDataFetcher.expectedDataResponse = (updatedContact, nil)
        let navigationController = UINavigationController(rootViewController: contactDetailViewController)
        
        UIApplication.shared.keyWindow!.rootViewController = navigationController
        
        let _ = navigationController.view
        let _ = contactDetailViewController.view
        
        contactDetailViewController.contactModalUpdatedBlock = {[weak self](updatedContactsDetailModal: ContactsDetailModalProtocol?) in
            self?.contactListViewModal.updateContact(existingIndexPath: IndexPath(row: 0, section: 0), newContact: updatedContactsDetailModal)
        }
        
        
        addEditViewController.contactModalUpdatedBlock = {[weak self](updatedContact) in
            self?.contactDetailViewController?.contactsDetailModal = updatedContact
            self?.contactDetailViewController?.viewModal?.setupWith(modal: updatedContact)
            self?.contactDetailViewController?.contactModalUpdatedBlock?(updatedContact)
        }

        addEditViewController.contactModalUpdatedBlock?(updatedContact)

//        XCTAssertEqual(contactListViewModal.groupedShortContacts[0][0].firstName, updatedContact.firstName, "Wrong data reflected on home from after fedited from edit details page")

        XCTAssertEqual(contactListViewModal.cellViewModals?[0][0].shortContact?.firstName, updatedContact.firstName, "Wrong data reflected on home from after edited from edit details page")
    }
    
}
