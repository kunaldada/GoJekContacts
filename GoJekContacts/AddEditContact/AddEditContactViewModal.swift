//
//  AddEditContactViewModal.swift
//  GoJekContacts
//
//  Created by ioshellboy on 15/06/19.
//  Copyright © 2019 ioshellboy. All rights reserved.
//

import UIKit

protocol AddEditContactViewModalProtocol {
    var cellViewModals: [AddEditContactCellViewModalProtocol]? {get set}
    func setupWith(modal: ContactsAddEditDetailModalProtocol?)
    var reloadTableData: (() -> (Void))? {get set}
    func validateAllDataAndSync()
    var validationCallBlock: ((_ syncSuccessfull: Bool,_ updatedContact: ContactsAddEditDetailModalProtocol?, _ errorMsg: String?) -> (Void))? {get set}
}

enum ContactKeys: CaseIterable {
    case profilePic
    case firstName
    case lastName
    case phoneNumber
    case email
    
    var displayValue: String {
        switch self {
        case .profilePic:
            return ""
        case .firstName:
            return "First Name"
        case .lastName:
            return "Last Name"
        case .phoneNumber:
            return "mobile"
        case .email:
            return "email"
        }
    }
    
    var postingValue: String {
        switch self {
        case .profilePic:
            return "profile_pic"
        case .firstName:
            return "first_name"
        case .lastName:
            return "last_name"
        case .phoneNumber:
            return "phone_number"
        case .email:
            return "email"
        }
    }

    var errorString: String {
        let commonString: String = "Please enter a valid "
        return commonString + self.displayValue
    }
    
    func checkIfValidResponseString(response: String?) -> Bool {
        guard let response = response else {
            return false
        }
        switch self {
        case .email:
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailTest.evaluate(with: response)
        case .phoneNumber:
            return true
        default:
            return true
        }
    }
}

class AddEditContactViewModal: AddEditContactViewModalProtocol {
    
    var detailModal: ContactsAddEditDetailModalProtocol?
    var cellViewModals: [AddEditContactCellViewModalProtocol]? {
        didSet {
            self.reloadTableData?()
        }
    }
    var reloadTableData: (() -> (Void))?
    var validationCallBlock: ((_ syncSuccessfull: Bool,_ updatedContact: ContactsAddEditDetailModalProtocol?, _ errorMsg: String?) -> (Void))?

    private var changedInfoValues: [ContactKeys: String] = [:]
    
    func setupWith(modal: ContactsAddEditDetailModalProtocol?) {
        self.detailModal = modal
        self.initCellViewModals()
    }
    
    private func initCellViewModals() {
        
        func getOtherCellViewModal(contactKey: ContactKeys, value: String?) -> AddEditContactOtherInfoCellViewModal {
            let otherInfoCellViewModal: AddEditContactOtherInfoCellViewModal = AddEditContactOtherInfoCellViewModal()
            otherInfoCellViewModal.contactKey = contactKey
            otherInfoCellViewModal.infoValue = value
            otherInfoCellViewModal.valueChangedBlock = {[weak self](contactKey, updatedValue) in
                if let contactKey = contactKey,
                    let updatedValue = updatedValue {
                    self?.changedInfoValues[contactKey] = updatedValue
                }
            }
            return otherInfoCellViewModal
        }
        
        var localCellViewModals: [AddEditContactCellViewModalProtocol] = []
        let profileCellViewModal: AddEditContactProfileCellViewModal = AddEditContactProfileCellViewModal()
        profileCellViewModal.contactKey = ContactKeys.profilePic
        profileCellViewModal.infoValue = self.detailModal?.profilePicUrlString
        localCellViewModals.append(profileCellViewModal)
        
        localCellViewModals.append(getOtherCellViewModal(contactKey: ContactKeys.firstName, value: self.detailModal?.firstName))
        
        localCellViewModals.append(getOtherCellViewModal(contactKey: ContactKeys.lastName, value: self.detailModal?.lastName))
        
        localCellViewModals.append(getOtherCellViewModal(contactKey: ContactKeys.phoneNumber,  value: self.detailModal?.mobileNumber))

        localCellViewModals.append(getOtherCellViewModal(contactKey: ContactKeys.email, value: self.detailModal?.emailAddress))
        
        self.cellViewModals = localCellViewModals
    }

    func validateAllDataAndSync() {
        if self.changedInfoValues.count == 0 {
            self.validationCallBlock?(false, nil,  nil)
            return
        }
        var appendedParameters: [String: String] = [:]
        if let contactId = self.detailModal?.contactIdentifier {
            // edit contact page, thus put call
            for (contactKey, updatedValue) in self.changedInfoValues {
                if contactKey.checkIfValidResponseString(response: updatedValue) == true {
                    appendedParameters[contactKey.postingValue] = updatedValue
                }
                else {
                    // return callback with error message
                    self.validationCallBlock?(false, nil, contactKey.errorString)
                    return
                }
            }
            self.putDataToServer(contactId: contactId, appendedParameters: appendedParameters)
        }
        else {
            // add contact page, thus post call
            for contactKey in ContactKeys.allCases {
                if contactKey != .profilePic {
                    if self.changedInfoValues[contactKey] != nil {
                        if contactKey.checkIfValidResponseString(response: self.changedInfoValues[contactKey]) == true {
                            appendedParameters[contactKey.postingValue] = self.changedInfoValues[contactKey]
                        }
                        else {
                            // return callback with error message
                            self.validationCallBlock?(false, nil, contactKey.errorString)
                            return
                        }
                    }
                    else {
                        self.validationCallBlock?(false, nil, contactKey.errorString)
                        return
                    }
                }
            }
            self.postDataToServer(appendedParameters: appendedParameters)
        }
    }

    private func putDataToServer(contactId: Int, appendedParameters: [String: String]) {
        let dataFetcher = DataFetcher.shared
        let urlString = String(format: "http://gojek-contacts-app.herokuapp.com/contacts/%@.json", String(contactId))
        let urlObject = URLObject(urlString: urlString, dataRequestType: .put, appendedParameters: appendedParameters)
        dataFetcher.fetchData(dataRequestor: urlObject, success: {[weak self] (response: ContactModal?) -> (Void) in
            if let reponse = response {
                self?.validationCallBlock?(true, reponse, nil)
            }
            else {
                self?.validationCallBlock?(false, nil, GenericStringConstants.networkProblem)
            }
        }) {[weak self] (error) -> (Void) in
            self?.validationCallBlock?(false, nil, GenericStringConstants.networkProblem)
        }
    }
    
    private func postDataToServer(appendedParameters: [String: String]) {
        let dataFetcher = DataFetcher.shared
        let urlObject = URLObject(urlString: "http://gojek-contacts-app.herokuapp.com/contacts.json", dataRequestType: .post, appendedParameters: appendedParameters)
        dataFetcher.fetchData(dataRequestor: urlObject, success: {[weak self] (response: ContactModal?) -> (Void) in
            if let reponse = response {
                self?.validationCallBlock?(true, reponse, nil)
            }
            else {
                self?.validationCallBlock?(false, nil, GenericStringConstants.networkProblem)
            }
        }) {[weak self] (error) -> (Void) in
            self?.validationCallBlock?(false, nil, GenericStringConstants.networkProblem)
        }
    }
    
}
