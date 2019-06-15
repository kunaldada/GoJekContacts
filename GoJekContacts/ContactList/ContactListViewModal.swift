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
    
//    var groupedShortContactsDi
    var shortContacts: [ShortContactModal]?
    
    var dataFetched: (() -> (Void))?
    
    internal func getContactsList() {
        let dataFetcher = DataFetcher.shared
        let urlObject = URLObject(urlString: "http://gojek-contacts-app.herokuapp.com/contacts.json", dataRequestType: .get, appendedParameters: nil)
        dataFetcher.fetchData(dataRequestor: urlObject, success: { (response: [ShortContactModal]?) -> (Void) in
//            if let response: [ShortContactModal] = response {
//                let groupedDictionary = Dictionary(grouping: response) { $0.firstName?.prefix(1) }
//            }
//
//
//            self.shortContacts?.sort(by: {$0.firstName > $1.firstName})
            self.shortContacts = response
            self.prepareCellViewModals()

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
