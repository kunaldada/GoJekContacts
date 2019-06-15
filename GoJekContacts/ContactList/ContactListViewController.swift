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
        self.customizeNavigationBar()
        self.contactListTableView.register(UINib(nibName: CellReuseIdentifierConstants.contactListTableViewCell, bundle: nil), forCellReuseIdentifier: CellReuseIdentifierConstants.contactListTableViewCell)
        self.initViewModal()
        // Do any additional setup after loading the view.
    }
    
    private func customizeNavigationBar() {
        self.title = GenericStringConstants.contactListViewNavigationTitle
        let leftItem = UIBarButtonItem(title: GenericStringConstants.contactListLeftNavigationButtonTitle, style: .plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItem = leftItem
        
        let rightItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewContact))
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    private func initViewModal() {
        self.viewModal?.dataFetched = {
            self.contactListTableView.reloadData()
        }
        self.viewModal?.getContactsList()
    }
    
    @objc private func addNewContact() {
        let addNewContactViewController = AddEditContactViewController(addEditModal: nil)
        let navigationController = UINavigationController(rootViewController: addNewContactViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
}
extension ContactListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModal?.cellViewModals?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier: String = CellReuseIdentifierConstants.contactListTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        (cell as? ContactListTableViewCell)?.bindData(cellViewModal: viewModal?.cellViewModals?[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cellViewModalsList = viewModal?.cellViewModals,
            cellViewModalsList.count > indexPath.row else {return}
        
        guard let detailViewModal = cellViewModalsList[indexPath.row].shortContact else {return}
        
        if let detailViewController = ContactDetailViewController(detailModal: detailViewModal) {
            self.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }

}
