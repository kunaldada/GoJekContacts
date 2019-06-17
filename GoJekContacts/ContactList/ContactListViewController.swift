//
//  ContactListViewController.swift
//  GoJekContacts
//
//  Created by ioshellboy on 13/06/19.
//  Copyright © 2019 ioshellboy. All rights reserved.
//

import UIKit

class ContactListViewController: UIViewController {

    @IBOutlet weak var contactListTableView: UITableView!
    var viewModal: ContactListViewModalProtocol? = ContactListViewModal()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavigationBarButtons()
        self.contactListTableView.register(UINib(nibName: CellReuseIdentifierConstants.contactListTableViewCell, bundle: nil), forCellReuseIdentifier: CellReuseIdentifierConstants.contactListTableViewCell)
        self.initViewModal()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.customizeNavBar()
    }
    
    private func customizeNavBar() {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = UIColor.white
    }
    
    private func addNavigationBarButtons() {
        self.title = GenericStringConstants.contactListViewNavigationTitle
        let leftItem = UIBarButtonItem(title: GenericStringConstants.contactListLeftNavigationButtonTitle, style: .plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItem = leftItem
        
        let rightItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewContact))
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    private func initViewModal() {
        self.viewModal?.dataFetched = {(reloadType: ReloadType) in
            switch reloadType {
            case .reloadAll:
                self.contactListTableView.reloadData()
            case .reloadIndex(let indexPath):
                guard let indexPath = indexPath else {return}
                self.contactListTableView.reloadRows(at: [indexPath], with: .automatic)
            default:
                break
            }   
        }
        self.viewModal?.getContactsList()
    }
    
    @objc private func addNewContact() {
        let addNewContactViewController = AddEditContactViewController(addEditModal: nil)
        addNewContactViewController.contactModalUpdatedBlock = {[weak self](updatedContact) in
            self?.viewModal?.updateContact(existingIndexPath: nil, newContact: updatedContact)
        }
        let navigationController = UINavigationController(rootViewController: addNewContactViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
}
extension ContactListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModal?.cellViewModals?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let totalList = self.viewModal?.cellViewModals, totalList.count > section {
            return totalList[section].count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier: String = CellReuseIdentifierConstants.contactListTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        (cell as? ContactListTableViewCell)?.bindData(cellViewModal: viewModal?.cellViewModals?[indexPath.section][indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cellViewModalsAllList = viewModal?.cellViewModals,
                    cellViewModalsAllList.count > indexPath.section,
                            cellViewModalsAllList[indexPath.section].count > indexPath.row else {return}
        
        guard let detailViewModal = cellViewModalsAllList[indexPath.section][indexPath.row].shortContact else {return}
        
        if let detailViewController = ContactDetailViewController(detailModal: detailViewModal, dataFetcher: DataFetcher.shared) {
            detailViewController.contactModalUpdatedBlock = {[weak self](updatedContactsDetailModal: ContactsDetailModalProtocol?) in
                self?.viewModal?.updateContact(existingIndexPath: indexPath, newContact: updatedContactsDetailModal)
            }
            self.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.viewModal?.existingTitles[section]
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.viewModal?.indexTitles
    }

    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return self.viewModal?.indexTitles.firstIndex(of: title) ?? 0
    }

}
