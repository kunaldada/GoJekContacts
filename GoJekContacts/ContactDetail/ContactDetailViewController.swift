    //
    //  ContactDetailViewController.swift
    //  GoJekContacts
    //
    //  Created by ioshellboy on 13/06/19.
    //  Copyright © 2019 ioshellboy. All rights reserved.
    //
    
    import UIKit
    
    protocol ContactsDetailModalProtocol {
        var fullName: String? {get}
        var contactIdentifier: Int? {get}
        var profilePicUrlString: String? {get}
        var favoriteStatus: Bool?  {get}
        var mobileNumber: String? {get}
        var emailAddress: String? {get}
        var hasValidMobile: Bool {get}
        var hasValidEmail: Bool {get}
        var hasCompleteDisplayInfo: Bool {get}
    }
    
    class ContactDetailViewController: UIViewController {
        
        var viewModal: ContactDetailViewModalProtocol?
        var contactsDetailModal: ContactsDetailModalProtocol?
        @IBOutlet weak var detailTableView: UITableView!
        override func viewDidLoad() {
            super.viewDidLoad()
            self.detailTableView.register(UINib(nibName: "ContactDetailInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "ContactDetailInfoTableViewCell")
            self.detailTableView.register(UINib(nibName: "ContactDetailProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ContactDetailProfileTableViewCell")
            // Do any additional setup after loading the view.
        }
        
        init?(detailModal: ContactsDetailModalProtocol?) {
            guard let detailModal = detailModal else {return nil}
            super.init(nibName: "ContactDetailViewController", bundle: nil)
            self.contactsDetailModal = detailModal
            self.viewModal = ContactDetailViewModal()
            self.viewModal?.setupWith(modal: detailModal)
            self.viewModal?.dataFetched = {
                self.detailTableView.reloadData()
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
        
    }
    
    extension ContactDetailViewController: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.viewModal?.cellViewModals?.count ?? 0
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cellViewModalList = self.viewModal?.cellViewModals,
                cellViewModalList.count > indexPath.row else {return UITableViewCell()}
            
            let cellViewModal = cellViewModalList[indexPath.row]
            if let profileCellViewModal = cellViewModal as? ContactDetailProfileCellViewModal {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ContactDetailProfileTableViewCell", for: indexPath)
                (cell as? ContactDetailProfileTableViewCell)?.bindData(cellViewModal: profileCellViewModal)
                cell.selectionStyle = .none
                return cell
            }
            else if let infoCellViewModal = cellViewModal as? ContactDetailInfoCellViewModal {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ContactDetailInfoTableViewCell", for: indexPath)
                (cell as? ContactDetailInfoTableViewCell)?.bindData(cellViewModal: infoCellViewModal)
                cell.selectionStyle = .none
                return cell
            }
            return UITableViewCell()
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            guard let cellViewModalList = self.viewModal?.cellViewModals,
                cellViewModalList.count > indexPath.row else {return 0}
            
            let cellViewModal = cellViewModalList[indexPath.row]
            if let _ = cellViewModal as? ContactDetailProfileCellViewModal {
                return 271
            }
            else if let _ = cellViewModal as? ContactDetailInfoCellViewModal {
                return 56
            }
            return 0
        }
        
    }
    
    
