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
}

class AddEditContactViewModal: AddEditContactViewModalProtocol {
    var detailModal: ContactsAddEditDetailModalProtocol?
    var cellViewModals: [AddEditContactCellViewModalProtocol]? {
        didSet {
            self.reloadTableData?()
        }
    }
    var reloadTableData: (() -> (Void))?
    
    func setupWith(modal: ContactsAddEditDetailModalProtocol?) {
        self.detailModal = modal
        self.initCellViewModals()
    }
    
    private func initCellViewModals() {
        
        func getOtherCellViewModal(key: String?, displayKey: String?, value: String?) -> AddEditContactOtherInfoCellViewModal {
            let otherInfoCellViewModal: AddEditContactOtherInfoCellViewModal = AddEditContactOtherInfoCellViewModal()
            otherInfoCellViewModal.infoKey = key
            otherInfoCellViewModal.displayKey = displayKey
            otherInfoCellViewModal.infoValue = value
            return otherInfoCellViewModal
        }
        
        var localCellViewModals: [AddEditContactCellViewModalProtocol] = []
        let profileCellViewModal: AddEditContactProfileCellViewModal = AddEditContactProfileCellViewModal()
        profileCellViewModal.infoKey = "profile_pic"
        profileCellViewModal.infoValue = self.detailModal?.profilePicUrlString
        localCellViewModals.append(profileCellViewModal)
        
        localCellViewModals.append(getOtherCellViewModal(key: "first_name", displayKey: "First Name", value: self.detailModal?.firstName))
        
        localCellViewModals.append(getOtherCellViewModal(key: "last_name", displayKey: "Last Name", value: self.detailModal?.lastName))
        
        localCellViewModals.append(getOtherCellViewModal(key: "phone_number", displayKey: "mobile",  value: self.detailModal?.mobileNumber))

        localCellViewModals.append(getOtherCellViewModal(key: "email", displayKey: "email", value: self.detailModal?.emailAddress))
        
        self.cellViewModals = localCellViewModals
    }


}
