//
//  ContactDetailCellViewModal.swift
//  GoJekContacts
//
//  Created by ioshellboy on 14/06/19.
//  Copyright © 2019 ioshellboy. All rights reserved.
//

import UIKit

protocol ContactDetailCellViewModalProtocol {
    func setup(modal: ContactsDetailModalProtocol?)
    func setup(key: String?, value: String?)
}
extension ContactDetailCellViewModalProtocol {
    func setup(modal: ContactsDetailModalProtocol?) {}
    func setup(key: String?, value: String?) {}
}

enum ContactActionType {
    case message
    case call
    case email
    case favorite
}

class ContactDetailProfileCellViewModal: ContactDetailCellViewModalProtocol {
    var detailModal: ContactsDetailModalProtocol?
    func setup(modal: ContactsDetailModalProtocol?) {
        self.detailModal = modal
    }
    
    var userSelectedAction: ((ContactActionType) -> (Void))?
    
    func messageSelected() {
        self.userSelectedAction?(.message)
    }
    
    func callSelected() {
        self.userSelectedAction?(.call)
    }
    
    func emailSelected() {
        self.userSelectedAction?(.email)
    }
    
    func favoriteSelected() {
        self.userSelectedAction?(.favorite)
    }
    
}

class ContactDetailInfoCellViewModal: ContactDetailCellViewModalProtocol {
    var infoKey: String?
    var infoValue: String?
    func setup(key: String?, value: String?) {
        self.infoKey = key
        self.infoValue = value
    }
}

