    //
    //  ContactDetailViewController.swift
    //  GoJekContacts
    //
    //  Created by ioshellboy on 13/06/19.
    //  Copyright © 2019 ioshellboy. All rights reserved.
    //
    
    import UIKit
    import MessageUI
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
        var contactModalUpdatedBlock: ((_ updatedContactsDetailModal: ContactsDetailModalProtocol?) -> (Void))?
        private var updatedContactsDetailModal: ContactsDetailModalProtocol?
        private var dataFetcher: DataFetcherProtocol?
        
        @IBOutlet weak var detailTableView: UITableView!
        override func viewDidLoad() {
            super.viewDidLoad()
            self.detailTableView.register(UINib(nibName: CellReuseIdentifierConstants.contactDetailInfoTableViewCell, bundle: nil), forCellReuseIdentifier: CellReuseIdentifierConstants.contactDetailInfoTableViewCell)
            self.detailTableView.register(UINib(nibName: CellReuseIdentifierConstants.contactDetailProfileTableViewCell, bundle: nil), forCellReuseIdentifier: CellReuseIdentifierConstants.contactDetailProfileTableViewCell)
            self.initViewModal()
            self.addNavigationBarButtons()
            print("did load")
            // Do any additional setup after loading the view.
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.customizeNavigationBar()
        }
        
        
        init?(detailModal: ContactsDetailModalProtocol?, dataFetcher: DataFetcherProtocol?) {
            guard let detailModal = detailModal else {return nil}
            super.init(nibName: "ContactDetailViewController", bundle: nil)
            self.contactsDetailModal = detailModal
            self.dataFetcher = dataFetcher
        }
        
        private func initViewModal() {
            self.viewModal = ContactDetailViewModal()
            self.viewModal?.dataFetcher = self.dataFetcher
            self.viewModal?.dataFetched = {[weak self] in
                self?.detailTableView.reloadData()
            }
            self.viewModal?.updateWithDetailedContact = {[weak self](updatedContactsDetailModal, transmitChanges) in
                self?.updatedContactsDetailModal = updatedContactsDetailModal
                if transmitChanges {
                    self?.contactModalUpdatedBlock?(updatedContactsDetailModal)
                }
            }
            self.viewModal?.userSelectedAction = {[weak self] (actionType: ContactActionType) in
                self?.userSelectedAction(actionType: actionType)
            }
            self.viewModal?.setupWith(modal: self.contactsDetailModal)
        }
        
        private func addNavigationBarButtons() {
            let rightItem = UIBarButtonItem(title: GenericStringConstants.contactDetailRightNavigationButtonTitle, style: .plain, target: self, action: #selector(editContactPressed))
            self.navigationItem.rightBarButtonItem = rightItem
        }
        
        private func customizeNavigationBar() {
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.view.backgroundColor = UIColor.white
        }

        @objc private func editContactPressed() {
            guard  let  updatedContactsDetailModal = self.updatedContactsDetailModal else {
                return
            }
            let editContactViewController = AddEditContactViewController(addEditModal: updatedContactsDetailModal)
            editContactViewController.contactModalUpdatedBlock = {[weak self](updatedContact) in
                self?.contactsDetailModal = updatedContact
                self?.viewModal?.setupWith(modal: self?.contactsDetailModal)
                self?.contactModalUpdatedBlock?(updatedContact)
            }
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
        
        private func userSelectedAction(actionType: ContactActionType) {
            switch actionType {
            case .call:
                guard let phoneNumber = self.updatedContactsDetailModal?.mobileNumber,
                    let isValidPhone = self.updatedContactsDetailModal?.hasValidMobile,
                        isValidPhone,
                            let numberUrl = URL(string: "tel://" + phoneNumber) else { return }
                UIApplication.shared.open(numberUrl)
            
            case .message:
                guard let phoneNumber = self.updatedContactsDetailModal?.mobileNumber,
                    let isValidPhone = self.updatedContactsDetailModal?.hasValidMobile,
                    isValidPhone else {return}

                if (MFMessageComposeViewController.canSendText()) {
                    let controller = MFMessageComposeViewController()
                    controller.body = ""
                    controller.recipients = [phoneNumber]
                    controller.messageComposeDelegate = self
                    self.present(controller, animated: true, completion: nil)
                }
                
            case .email:
                guard let emailAddress = self.updatedContactsDetailModal?.emailAddress,
                    let isValidEmail = self.updatedContactsDetailModal?.hasValidEmail,
                    isValidEmail else {return}

                if MFMailComposeViewController.canSendMail() {
                    let composer = MFMailComposeViewController()
                    composer.mailComposeDelegate = self
                    composer.setToRecipients([emailAddress])
                    composer.setSubject("")
                    composer.setMessageBody("", isHTML: false)
                    self.present(composer, animated: true, completion: nil)
                }
                
            default:
                break
            }
        }
        
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
    
    extension ContactDetailViewController: MFMessageComposeViewControllerDelegate {
        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    extension ContactDetailViewController: MFMailComposeViewControllerDelegate {
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            self.dismiss(animated: true, completion: nil)
        }
    }

