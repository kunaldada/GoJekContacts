//
//  AddEditContactViewController.swift
//  GoJekContacts
//
//  Created by ioshellboy on 15/06/19.
//  Copyright © 2019 ioshellboy. All rights reserved.
//

import UIKit

class AddEditContactViewController: UIViewController {

    @IBOutlet weak var addEditContactDetailTableView: UITableView!
    var addEditModal: ContactsAddEditDetailModalProtocol?
    private var viewModal: AddEditContactViewModalProtocol?
    var contactModalUpdatedBlock: ((_ updatedContactsDetailModal: ContactsDetailModalProtocol?) -> (Void))?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addEditContactDetailTableView.register(UINib(nibName: CellReuseIdentifierConstants.editContactOtherInfoTableViewCell, bundle: nil), forCellReuseIdentifier: CellReuseIdentifierConstants.editContactOtherInfoTableViewCell)
        self.addEditContactDetailTableView.register(UINib(nibName: CellReuseIdentifierConstants.editContactProfileTableViewCell, bundle: nil), forCellReuseIdentifier: CellReuseIdentifierConstants.editContactProfileTableViewCell)
        
        // Do any additional setup after loading the view.
    }

    init(addEditModal: ContactsAddEditDetailModalProtocol?) {
        super.init(nibName: "AddEditContactViewController", bundle: nil)
        self.addEditModal = addEditModal
        self.initViewModal()
        self.customizeNavigationBar()
    }
    
    private func initViewModal() {
        self.viewModal = AddEditContactViewModal()
        self.viewModal?.dataFetcher = DataFetcher.shared
        self.viewModal?.setupWith(modal: self.addEditModal)
        self.viewModal?.reloadTableData = {[weak self] in
            self?.addEditContactDetailTableView.reloadData()
        }
        self.viewModal?.validationCallBlock = {(syncSuccessfull: Bool, updatedContact: ContactsAddEditDetailModalProtocol?, errorMsg: String?) in
            if let errorMsg = errorMsg {
                self.showErrorMessage(errorMessage: errorMsg)
            }
            else if let serverErrors = updatedContact?.errors, serverErrors.count > 0 {
                self.showErrorMessage(errorMessage: serverErrors[0])
            }
            else {
                self.contactModalUpdatedBlock?(updatedContact as? ContactsDetailModalProtocol)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func customizeNavigationBar() {

        let leftItem = UIBarButtonItem(title: GenericStringConstants.contactEditLeftNavigationButtonTitle, style: .plain, target: self, action: #selector(cancelPressed))
        self.navigationItem.leftBarButtonItem = leftItem
        
        let rightItem = UIBarButtonItem(title: GenericStringConstants.contactEditRightNavigationButtonTitle, style: .plain, target: self, action: #selector(donePressed))
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc private func donePressed() {
        self.viewModal?.validateAllDataAndSync()
    }

    @objc private func cancelPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func showErrorMessage(errorMessage: String) {
        let alert: UIAlertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
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

extension AddEditContactViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModal?.cellViewModals?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellViewModalList = self.viewModal?.cellViewModals,
            cellViewModalList.count > indexPath.row else {return UITableViewCell()}
        
        let cellViewModal = cellViewModalList[indexPath.row]
        if let profileCellViewModal = cellViewModal as? AddEditContactProfileCellViewModal {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseIdentifierConstants.editContactProfileTableViewCell, for: indexPath)
            (cell as? EditContactProfileTableViewCell)?.bindData(cellViewModal: profileCellViewModal)
            cell.selectionStyle = .none
            return cell
        }
        else if let infoCellViewModal = cellViewModal as? AddEditContactOtherInfoCellViewModal {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseIdentifierConstants.editContactOtherInfoTableViewCell, for: indexPath)
            (cell as? EditContactOtherInfoTableViewCell)?.bindData(cellViewModal: infoCellViewModal)
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let cellViewModalList = self.viewModal?.cellViewModals,
            cellViewModalList.count > indexPath.row else {return 0}
        
        let cellViewModal = cellViewModalList[indexPath.row]
        if let _ = cellViewModal as? AddEditContactProfileCellViewModal {
            return 255
        }
        else if let _ = cellViewModal as? AddEditContactOtherInfoCellViewModal {
            return 56
        }
        return 0
    }
    
    
}

protocol ContactsAddEditDetailModalProtocol {
    var firstName: String? {get}
    var lastName: String? {get}
    var contactIdentifier: Int? {get}
    var profilePicUrlString: String? {get}
    var mobileNumber: String? {get}
    var emailAddress: String? {get}
    var errors: [String]? {get}
}
