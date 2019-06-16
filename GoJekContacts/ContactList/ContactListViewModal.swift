//
//  ContactListViewModal.swift
//  GoJekContacts
//
//  Created by ioshellboy on 13/06/19.
//  Copyright © 2019 ioshellboy. All rights reserved.
//

import UIKit
import SVProgressHUD
protocol ContactListViewModalProtocol {
    //    associatedtype CellViewModalProtocol: ContactListCellViewModalProtocol
    var cellViewModals: [[ContactListCellViewModalProtocol]]? {get set}
    var dataFetched: ((_ reloadType: ReloadType) -> (Void))? {get set}
    func getContactsList()
    var existingTitles: [String] {get set}
    var indexTitles: [String] {get set}
    func updateContact(existingIndexPath: IndexPath?, newContact:ContactsDetailModalProtocol?)
}

enum ReloadType {
    case reloadAll
    case reloadIndex(indexPath: IndexPath?)
    case insertIndex(indexPath: IndexPath?)
    case batch(insertIndexPaths: [IndexPath]?, deleteIndexPaths: [IndexPath]?, reloadIndexPath: [IndexPath]?)
}

class ContactListViewModal: ContactListViewModalProtocol {
    
    var cellViewModals: [[ContactListCellViewModalProtocol]]?
    
    var existingTitles: [String] = []
    var groupedShortContacts: [[ContactsDetailModalProtocol]] = []
    var shortContacts: [ContactsDetailModalProtocol]?
    
    internal var indexTitles: [String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "#"]
    
    
    var dataFetched: ((_ reloadType: ReloadType) -> (Void))?
    
    internal func getContactsList() {
        SVProgressHUD.setDefaultMaskType(.gradient)
        SVProgressHUD.show()
        let dataFetcher = DataFetcher.shared
        let urlObject = URLObject(urlString: "http://gojek-contacts-app.herokuapp.com/contacts.json", dataRequestType: .get, appendedParameters: nil)
        
        dataFetcher.fetchData(dataRequestor: urlObject, success: {[weak self] (response: [ShortContactModal]?) -> (Void) in
            SVProgressHUD.dismiss()
            self?.shortContacts = response
            self?.prepareCellViewModals()
            }, failure: { (_) -> (Void) in
                SVProgressHUD.dismiss()
        })
    }
    
    func prepareCellViewModals() {
        
        guard let shortContactList = self.shortContacts else {
            return
        }
        var overAllCellViewModalsList: [[ContactListCellViewModal]] = []
        var localGroupShortContacts: [[ContactsDetailModalProtocol]] = []
        for _ in 0..<indexTitles.count {
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
        self.dataFetched?(.reloadAll)
    }
    
    func updateContact(existingIndexPath: IndexPath?, newContact:ContactsDetailModalProtocol?) {
        guard let newContact = newContact else{return}
        
        if let existingIndexPath = existingIndexPath
        {
            let existingContact: ContactsDetailModalProtocol = groupedShortContacts[existingIndexPath.section][existingIndexPath.row]
            // existing contact case
            if existingContact.fullName == newContact.fullName {
                // no need to reorder.just reload
                self.cellViewModals?[existingIndexPath.section][existingIndexPath.row].shortContact = newContact
                self.dataFetched?(.reloadIndex(indexPath: existingIndexPath))
            }
            else {
                //TODO: update logic
                // might need reorder. moving by brute force for now
                if let foundIndex = shortContacts?.firstIndex(where: { (findContact) -> Bool in
                    return findContact.contactIdentifier == existingContact.contactIdentifier
                }) {
                    shortContacts?[foundIndex] = newContact
                    self.prepareCellViewModals()
                }
            }
        }
        else {
            //TODO: update logic
            // new contact case. moving by brute force for now
            shortContacts?.append(newContact)
            self.prepareCellViewModals()
        }
    }
}
