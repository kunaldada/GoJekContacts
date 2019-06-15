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
    var cellViewModals: [[ContactListCellViewModalProtocol]]? {get set}
    var dataFetched: (() -> (Void))? {get set}
    func getContactsList()
    var existingTitles: [String] {get set}
    var indexTitles: [String] {get set}
}

class ContactListViewModal: ContactListViewModalProtocol {
    
    var cellViewModals: [[ContactListCellViewModalProtocol]]? {
        didSet {
            self.dataFetched?()
        }
    }
    
    var existingTitles: [String] = []
    var groupedShortContacts: [[ShortContactModal]] = []
    var shortContacts: [ShortContactModal]? {
        didSet {
            self.prepareCellViewModals()
        }
    }
    internal var indexTitles: [String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "#"]
    
    
    var dataFetched: (() -> (Void))?
    
    internal func getContactsList() {
        let dataFetcher = DataFetcher.shared
        let urlObject = URLObject(urlString: "http://gojek-contacts-app.herokuapp.com/contacts.json", dataRequestType: .get, appendedParameters: nil)
        dataFetcher.fetchData(dataRequestor: urlObject, success: { (response: [ShortContactModal]?) -> (Void) in
            self.shortContacts = response
        }, failure: nil)
    }
    
    func prepareCellViewModals() {
        
        guard let shortContactList = self.shortContacts else {
            return
        }
        var overAllCellViewModalsList: [[ContactListCellViewModal]] = []
        var localGroupShortContacts: [[ShortContactModal]] = []
        for index in 0..<indexTitles.count {
            localGroupShortContacts.append([])
        }
        
        for shortContact in shortContactList {
            if let firstUpperCaseLetter = shortContact.fullName?.prefix(1).uppercased() {
                if let index = indexTitles.firstIndex(of: firstUpperCaseLetter), index < indexTitles.count {
                    localGroupShortContacts[index].append(shortContact)
                }
                else {
                    localGroupShortContacts[indexTitles.count-1].append(shortContact)
                }
            }
        }
        
        for index in 0..<localGroupShortContacts.count {
            var indexGroup = localGroupShortContacts[index]
            if indexGroup.count > 0 {
                indexGroup.sort { (s1, s2) -> Bool in
                    if let s1Name = s1.fullName, let s2Name = s2.fullName {
                        return s1Name.localizedCaseInsensitiveCompare(s2Name) == ComparisonResult.orderedAscending
                    }
                    return false
                }
                
                let cellViewModalsList: [ContactListCellViewModal] = indexGroup.map({ (elementOfCollection) -> ContactListCellViewModal in
                    let cellViewModal: ContactListCellViewModal = ContactListCellViewModal()
                    cellViewModal.shortContact = elementOfCollection
                    return cellViewModal
                })
                
                self.groupedShortContacts.append(indexGroup)
                self.existingTitles.append(indexTitles[index])
                overAllCellViewModalsList.append(cellViewModalsList)
            }
            else {
                // do nothing
            }
        }
        self.cellViewModals = overAllCellViewModalsList
    }
}
