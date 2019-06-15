//
//  AddEditContactCellViewModal.swift
//  GoJekContacts
//
//  Created by ioshellboy on 15/06/19.
//  Copyright © 2019 ioshellboy. All rights reserved.
//

import UIKit

protocol AddEditContactCellViewModalProtocol {
    var infoKey: String? {get set}
    var displayKey: String? {get set}
    var infoValue: String? {get set}
}

class AddEditContactProfileCellViewModal: AddEditContactCellViewModalProtocol {
    var infoKey: String?
    var displayKey: String?
    var infoValue: String?
}

class AddEditContactOtherInfoCellViewModal: AddEditContactCellViewModalProtocol {
    var infoKey: String?
    var displayKey: String?
    var infoValue: String?
}
