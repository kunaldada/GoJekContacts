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


class ContactDetailProfileCellViewModal: ContactDetailCellViewModalProtocol {
    var detailModal: ContactsDetailModalProtocol?
    func setup(modal: ContactsDetailModalProtocol?) {
        self.detailModal = modal
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

