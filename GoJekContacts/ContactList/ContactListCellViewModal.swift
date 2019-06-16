//
//  ContactListCellViewModal.swift
//  GoJekContacts
//
//  Created by ioshellboy on 13/06/19.
//  Copyright © 2019 ioshellboy. All rights reserved.
//

import UIKit

protocol ContactListCellViewModalProtocol {
    var shortContact: ContactsDetailModalProtocol? {get set}
}

class ContactListCellViewModal: ContactListCellViewModalProtocol {
    var shortContact: ContactsDetailModalProtocol?
}
