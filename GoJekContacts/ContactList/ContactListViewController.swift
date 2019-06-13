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
        self.contactListTableView.register(UINib(nibName: "ContactListTableViewCell", bundle: nil), forCellReuseIdentifier: "ContactListTableViewCell")
        self.viewModal?.dataFetched = {
            self.contactListTableView.reloadData()
        }
        self.viewModal?.getContactsList()
        // Do any additional setup after loading the view.
    }
}
extension ContactListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModal?.cellViewModals?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier: String = "ContactListTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        (cell as? ContactListTableViewCell)?.bindData(cellViewModal: viewModal?.cellViewModals?[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

}
