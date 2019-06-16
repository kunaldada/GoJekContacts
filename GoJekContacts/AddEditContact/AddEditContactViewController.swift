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
    
    static let profileCellHeight: CGFloat = 190
    static let otherInfoCellHeight: CGFloat = 56
    
    private var desiredOffset: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addEditContactDetailTableView.register(UINib(nibName: CellReuseIdentifierConstants.editContactOtherInfoTableViewCell, bundle: nil), forCellReuseIdentifier: CellReuseIdentifierConstants.editContactOtherInfoTableViewCell)
        self.addEditContactDetailTableView.register(UINib(nibName: CellReuseIdentifierConstants.editContactProfileTableViewCell, bundle: nil), forCellReuseIdentifier: CellReuseIdentifierConstants.editContactProfileTableViewCell)
        self.initViewModal()
        self.addNavigationBarButtons()
        NotificationCenter.default.addObserver(self, selector: #selector(self.willDisplayKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.customizeNavigationBar()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        for cell in self.addEditContactDetailTableView.visibleCells {
            if let cell = cell as? KeyboardDisplayer {
                cell.activateKeyboardResponder()
                break
            }
        }
    }
    
    init(addEditModal: ContactsAddEditDetailModalProtocol?) {
        super.init(nibName: "AddEditContactViewController", bundle: nil)
        self.addEditModal = addEditModal
    }
    
    private func initViewModal() {
        self.viewModal = AddEditContactViewModal()
        self.viewModal?.dataFetcher = DataFetcher.shared
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
                if let updatedContact = updatedContact {
                    self.contactModalUpdatedBlock?(updatedContact as? ContactsDetailModalProtocol)
                }
                self.dismiss(animated: true, completion: nil)
            }
        }
        self.viewModal?.setupWith(modal: self.addEditModal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addNavigationBarButtons() {
        let leftItem = UIBarButtonItem(title: GenericStringConstants.contactEditLeftNavigationButtonTitle, style: .plain, target: self, action: #selector(cancelPressed))
        self.navigationItem.leftBarButtonItem = leftItem
        
        let rightItem = UIBarButtonItem(title: GenericStringConstants.contactEditRightNavigationButtonTitle, style: .plain, target: self, action: #selector(donePressed))
        self.navigationItem.rightBarButtonItem = rightItem
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    private func customizeNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
    }
    
    @objc private func donePressed() {
        self.dismissAllKeyboards()
        self.viewModal?.validateAllDataAndSync()
    }

    @objc private func cancelPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func dismissAllKeyboards() {
        for cells in self.addEditContactDetailTableView.visibleCells {
            (cells as? KeyboardDisplayer)?.resignKeyboardResponder()
        }
    }
    
    private func showErrorMessage(errorMessage: String) {
        let alert: UIAlertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func willDisplayKeyboard(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            let padding: CGFloat = 150
            if self.desiredOffset < self.addEditContactDetailTableView.frame.size.height - keyboardHeight - padding {
                // do nothing
            }
            else {
                let setContentOffset = self.desiredOffset - (self.addEditContactDetailTableView.frame.size.height - keyboardHeight - padding)
                self.addEditContactDetailTableView.setContentOffset(CGPoint(x: 0, y: setContentOffset), animated: true)
            }
        }
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
            (cell as? EditContactOtherInfoTableViewCell)?.acknowledgementDelegate = self
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
            return AddEditContactViewController.profileCellHeight
        }
        else if let _ = cellViewModal as? AddEditContactOtherInfoCellViewModal {
            return AddEditContactViewController.otherInfoCellHeight
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismissAllKeyboards()
    }

    
}

extension AddEditContactViewController: KeyboardDisplayerAcknowledgment {
    func textFieldInCellBecameActive(cell: UITableViewCell?) {
        guard let cell = cell else {return}
        if let indexPath = self.addEditContactDetailTableView.indexPath(for: cell) {
            if indexPath.row > 0 {
                self.desiredOffset = AddEditContactViewController.profileCellHeight + CGFloat(indexPath.row - 1)*AddEditContactViewController.otherInfoCellHeight
            }
        }
    }
    
    func textFieldInCellBecameInactive(cell: UITableViewCell?) {
        self.desiredOffset = 0
        self.addEditContactDetailTableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
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
