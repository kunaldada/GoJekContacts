//
//  ContactDetailViewModal.swift
//  GoJekContacts
//
//  Created by ioshellboy on 14/06/19.
//  Copyright © 2019 ioshellboy. All rights reserved.
//

import UIKit

protocol ContactDetailViewModalProtocol {
    func setupWith(modal: ContactsDetailModalProtocol?)
    var cellViewModals: [ContactDetailCellViewModalProtocol]? {get set}
    var dataFetched: (() -> (Void))? {get set}
    var updateWithDetailedContact: ((_ detailModal: ContactsDetailModalProtocol?) -> (Void))? {get set}
}

class ContactDetailViewModal: ContactDetailViewModalProtocol {
    
    var detailModal: ContactsDetailModalProtocol?
    var cellViewModals: [ContactDetailCellViewModalProtocol]? {
        didSet {
            self.dataFetched?()
        }
    }
    var dataFetched: (() -> (Void))?
    var updateWithDetailedContact: ((_ detailModal: ContactsDetailModalProtocol?) -> (Void))?
    
    func setupWith(modal: ContactsDetailModalProtocol?) {
        self.detailModal = modal
        self.initCellViewModals()
        if self.detailModal?.hasCompleteDisplayInfo == false {
            self.fetchCompleteContactDetails()
        }
        else {
            self.updateWithDetailedContact?(self.detailModal)
        }
    }
    
    private func initCellViewModals() {
        var updatedCellViewModals: [ContactDetailCellViewModalProtocol] = []
        let profileCellViewModal: ContactDetailProfileCellViewModal = ContactDetailProfileCellViewModal()
        profileCellViewModal.setup(modal: self.detailModal)
        updatedCellViewModals.append(profileCellViewModal)
        if self.detailModal?.hasValidMobile == true {
            let otherInfoCellViewModal: ContactDetailInfoCellViewModal = ContactDetailInfoCellViewModal()
            otherInfoCellViewModal.setup(key: "mobile", value: self.detailModal?.mobileNumber)
            updatedCellViewModals.append(otherInfoCellViewModal)
        }
        if self.detailModal?.hasValidEmail == true {
            let otherInfoCellViewModal: ContactDetailInfoCellViewModal = ContactDetailInfoCellViewModal()
            otherInfoCellViewModal.setup(key: "email", value: self.detailModal?.emailAddress)
            updatedCellViewModals.append(otherInfoCellViewModal)
        }
        self.cellViewModals = updatedCellViewModals
    }
    
    private func fetchCompleteContactDetails() {
        guard let contactId = self.detailModal?.contactIdentifier else {return}
        
        let urlString = String(format: "https://gojek-contacts-app.herokuapp.com/contacts/%@.json", String(contactId))
        let dataFetcher = DataFetcher.shared
        let urlObject = URLObject(urlString: urlString, dataRequestType: .get, appendedParameters: nil)
        dataFetcher.fetchData(dataRequestor: urlObject, success: {[weak self] (response: ContactModal?) -> (Void) in
            self?.setupWith(modal: response)
        }) { (error) -> (Void) in
            
        }
    }
    
}

extension ShortContactModal: ContactsDetailModalProtocol {
    var contactIdentifier: Int? {
        return self.contactId
    }
    
    var profilePicUrlString: String? {
        return self.profilePic
    }
    
    var favoriteStatus: Bool? {
        return self.favorite
    }
    
    var mobileNumber: String? {
        return nil
    }
    
    var emailAddress: String? {
        return nil
    }
    
    var hasValidMobile: Bool {
        return false
    }
    
    var hasValidEmail: Bool {
        return false
    }
    
    var hasCompleteDisplayInfo: Bool {
        return false
    }
}

extension ContactModal: ContactsDetailModalProtocol {
    var fullName: String? {
        return self.getFullName()
    }
    
    var contactIdentifier: Int? {
        return self.contactId
    }
    
    var profilePicUrlString: String? {
        return self.profilePic
    }
    
    var favoriteStatus: Bool? {
        return self.favorite
    }
    
    var mobileNumber: String? {
        return self.phoneNumber
    }
    
    var emailAddress: String? {
        return self.email
    }
    
    var hasValidMobile: Bool {
        if let phone = self.phoneNumber, phone.isEmpty == false {
            return true
        }
        return false
    }
    
    var hasValidEmail: Bool {
        if let email = self.email, email.isEmpty == false {
            return true
        }
        return false
    }
    
    var hasCompleteDisplayInfo: Bool {
        return true
    }
}
