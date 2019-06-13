//
//  ContactListViewModal.swift
//  GoJekContacts
//
//  Created by ioshellboy on 13/06/19.
//  Copyright © 2019 ioshellboy. All rights reserved.
//

import UIKit

protocol ContactListViewModalProtocol {
//    associatedtype CellViewModalProtocol: ContactListCellViewModalProtocol
    var cellViewModals: [ContactListCellViewModalProtocol]? {get set}
    var dataFetched: (() -> (Void))? {get set}
    func getContactsList()
}

class ContactListViewModal: ContactListViewModalProtocol {
    
    var cellViewModals: [ContactListCellViewModalProtocol]? {
        didSet {
            self.dataFetched?()
        }
    }
    
    var shortContacts: [ShortContactModal]? {
        didSet {
            prepareCellViewModals()
        }
    }
    
    var dataFetched: (() -> (Void))?
    
    internal func getContactsList() {
        let dataFetcher = DataFetcher.shared
        let urlObject = URLObject(urlString: "http://gojek-contacts-app.herokuapp.com/contacts.json", dataRequestType: .get)
        dataFetcher.fetchData(dataRequestor: urlObject, success: { (response: [ShortContactModal]?) -> (Void) in
            self.shortContacts = response
        }) { (error) -> (Void) in
            
        }
    }
    
    private func prepareCellViewModals() {
        if let shortContacts = shortContacts {
            var cellViewModalsList: [ContactListCellViewModal] = []
            for shortContact in shortContacts {
                let cellViewModal: ContactListCellViewModal = ContactListCellViewModal()
                cellViewModal.shortContact = shortContact
                cellViewModalsList.append(cellViewModal)
            }
            self.cellViewModals = cellViewModalsList
        }
    }
}
