    //
    //  ContactDetailViewController.swift
    //  GoJekContacts
    //
    //  Created by ioshellboy on 13/06/19.
    //  Copyright © 2019 ioshellboy. All rights reserved.
    //
    
    import UIKit
    
    protocol ContactsDetailModalProtocol: ContactsAddEditDetailModalProtocol {
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
        private var updatedContactsDetailModal: ContactsDetailModalProtocol?
        @IBOutlet weak var detailTableView: UITableView!
        override func viewDidLoad() {
            super.viewDidLoad()
            self.detailTableView.register(UINib(nibName: CellReuseIdentifierConstants.contactDetailInfoTableViewCell, bundle: nil), forCellReuseIdentifier: CellReuseIdentifierConstants.contactDetailInfoTableViewCell)
            self.detailTableView.register(UINib(nibName: CellReuseIdentifierConstants.contactDetailProfileTableViewCell, bundle: nil), forCellReuseIdentifier: CellReuseIdentifierConstants.contactDetailProfileTableViewCell)
            // Do any additional setup after loading the view.
        }
        
        init?(detailModal: ContactsDetailModalProtocol?) {
            guard let detailModal = detailModal else {return nil}
            super.init(nibName: "ContactDetailViewController", bundle: nil)
            self.contactsDetailModal = detailModal
            self.initViewModal()
            self.customizeNavigationBar()
        }
        
        private func initViewModal() {
            self.viewModal = ContactDetailViewModal()
            self.viewModal?.setupWith(modal: self.contactsDetailModal)
            self.viewModal?.dataFetched = {[weak self] in
                self?.detailTableView.reloadData()
            }
            self.viewModal?.updateWithDetailedContact = {[weak self](updatedContactsDetailModal) in
                self?.updatedContactsDetailModal = updatedContactsDetailModal
            }
        }
        
        private func customizeNavigationBar() {
//            self.navigationController?.navigationBar.isTranslucent = true
//            self.navigationController?.view.backgroundColor = .clear
            let rightItem = UIBarButtonItem(title: GenericStringConstants.contactDetailRightNavigationButtonTitle, style: .plain, target: self, action: #selector(editContactPressed))
            self.navigationItem.rightBarButtonItem = rightItem
        }

        @objc private func editContactPressed() {
            guard  let  updatedContactsDetailModal = self.updatedContactsDetailModal else {
                return
            }
            let editContactViewController = AddEditContactViewController(addEditModal: updatedContactsDetailModal)
            let navigationController = UINavigationController(rootViewController: editContactViewController)
            self.present(navigationController, animated: true, completion: nil)
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
                let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseIdentifierConstants.contactDetailProfileTableViewCell, for: indexPath)
                (cell as? ContactDetailProfileTableViewCell)?.bindData(cellViewModal: profileCellViewModal)
                cell.selectionStyle = .none
                return cell
            }
            else if let infoCellViewModal = cellViewModal as? ContactDetailInfoCellViewModal {
                let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseIdentifierConstants.contactDetailInfoTableViewCell, for: indexPath)
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
    
    
