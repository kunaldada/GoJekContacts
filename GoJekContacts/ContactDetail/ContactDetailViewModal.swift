//
//  ContactDetailViewModal.swift
//  GoJekContacts
//
//  Created by ioshellboy on 14/06/19.
//  Copyright © 2019 ioshellboy. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol ContactDetailViewModalProtocol {
    func setupWith(modal: ContactsDetailModalProtocol?)
    var dataFetcher: DataFetcherProtocol? {get set}
    var cellViewModals: [ContactDetailCellViewModalProtocol]? {get set}
    var dataFetched: (() -> (Void))? {get set}
    var updateWithDetailedContact: ((_ detailModal: ContactsDetailModalProtocol?,_ transmitChanges: Bool) -> (Void))? {get set}
    var userSelectedAction: ((_ actionType: ContactActionType) -> (Void))? {get set}
}

class ContactDetailViewModal: ContactDetailViewModalProtocol {

    var detailModal: ContactsDetailModalProtocol?
    var dataFetcher: DataFetcherProtocol?
    var cellViewModals: [ContactDetailCellViewModalProtocol]? {
        didSet {
            self.dataFetched?()
        }
    }
    var dataFetched: (() -> (Void))?
    var updateWithDetailedContact: ((_ detailModal: ContactsDetailModalProtocol?,_ transmitChanges: Bool) -> (Void))?
    var userSelectedAction: ((_ actionType: ContactActionType) -> (Void))?
    
    func setupWith(modal: ContactsDetailModalProtocol?) {
        self.setupWith(modal: modal, transmitChanges: false)
    }
    
    private func setupWith(modal: ContactsDetailModalProtocol?, transmitChanges: Bool) {
        self.detailModal = modal
        self.initCellViewModals()
        if self.detailModal?.hasCompleteDisplayInfo == false {
            self.fetchCompleteContactDetails()
        }
        else {
            self.updateWithDetailedContact?(self.detailModal, transmitChanges)
        }
    }
    
    private func initCellViewModals() {
        var updatedCellViewModals: [ContactDetailCellViewModalProtocol] = []
        let profileCellViewModal: ContactDetailProfileCellViewModal = ContactDetailProfileCellViewModal()
        
        profileCellViewModal.userSelectedAction =  {[weak self](selectedAction: ContactActionType) in
            self?.userSelectedActionFromProfile(actionType: selectedAction)
        }
        
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
        let urlObject = URLObject(urlString: urlString, dataRequestType: .get, appendedParameters: nil)
        SVProgressHUD.setDefaultMaskType(.gradient)
        SVProgressHUD.show()
        dataFetcher?.fetchData(dataRequestor: urlObject, success: {[weak self] (response: ContactModal?) -> (Void) in
            SVProgressHUD.dismiss()
            self?.setupWith(modal: response, transmitChanges: false)
        }) { (error) -> (Void) in
            SVProgressHUD.dismiss()
        }
    }
    
    func userSelectedActionFromProfile(actionType: ContactActionType) {
        switch actionType {
        case .favorite:
            self.makeFavoriteCall()
        default:
            self.userSelectedAction?(actionType)
        }
    }
    
    private func makeFavoriteCall() {
        guard let contactId = self.detailModal?.contactIdentifier else {return}
        let appendedParameters: [String: Bool] = ["favorite": !(self.detailModal?.favoriteStatus ?? false)]
        let urlString = String(format: "http://gojek-contacts-app.herokuapp.com/contacts/%@.json", String(contactId))
        let urlObject = URLObject(urlString: urlString, dataRequestType: .put, appendedParameters: appendedParameters)
        SVProgressHUD.setDefaultMaskType(.gradient)
        SVProgressHUD.show()
        dataFetcher?.fetchData(dataRequestor: urlObject, success: {[weak self] (response: ContactModal?) -> (Void) in
            SVProgressHUD.dismiss()
            if let errors = response?.errors, errors.count > 0 {
                // invalid resonse
            }
            else {
                //valid response
                self?.setupWith(modal: response, transmitChanges: true)
            }
        }) { (error) -> (Void) in
            SVProgressHUD.dismiss()
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
