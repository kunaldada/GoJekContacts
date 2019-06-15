//
//  AddEditContactCellViewModal.swift
//  GoJekContacts
//
//  Created by ioshellboy on 15/06/19.
//  Copyright © 2019 ioshellboy. All rights reserved.
//

import UIKit

protocol AddEditContactCellViewModalProtocol {
    var contactKey: ContactKeys? {get set}
    var infoValue: String? {get set}
    var valueChangedBlock: ((_ contactKey: ContactKeys?, _ updatedValue: String?) -> (Void))? {get set}
}

class AddEditContactProfileCellViewModal: AddEditContactCellViewModalProtocol {
    var contactKey: ContactKeys?
    var infoValue: String?
    var valueChangedBlock: ((_ contactKey: ContactKeys?, _ updatedValue: String?) -> (Void))?
}

class AddEditContactOtherInfoCellViewModal: AddEditContactCellViewModalProtocol {
    var contactKey: ContactKeys?
    var infoValue: String?
    var valueChangedBlock: ((_ contactKey: ContactKeys?, _ updatedValue: String?) -> (Void))?
    
    func updateValue(updatedValue: String?) {
        if infoValue != updatedValue {
            self.valueChangedBlock?(self.contactKey, updatedValue)
        }
    }
}
