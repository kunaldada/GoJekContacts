//
//  EditContactOtherInfoTableViewCell.swift
//  GoJekContacts
//
//  Created by ioshellboy on 15/06/19.
//  Copyright © 2019 ioshellboy. All rights reserved.
//

import UIKit

protocol KeyboardDisplayer {
    var acknowledgementDelegate: KeyboardDisplayerAcknowledgment? {get set}
    func resignKeyboardResponder()
    func activateKeyboardResponder()
}

protocol KeyboardDisplayerAcknowledgment {
    func textFieldInCellBecameActive(cell: UITableViewCell?)
    func textFieldInCellBecameInactive(cell: UITableViewCell?)
}


class EditContactOtherInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var infoKeyLabel: UILabel!
    @IBOutlet weak var infoValueTextField: UITextField!
    
    var cellViewModal: AddEditContactOtherInfoCellViewModal?
    
    var acknowledgementDelegate: KeyboardDisplayerAcknowledgment?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.infoValueTextField.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindData(cellViewModal: AddEditContactOtherInfoCellViewModal?) {
        self.cellViewModal = cellViewModal
        self.infoKeyLabel.text = cellViewModal?.contactKey?.displayValue
        self.infoValueTextField.text = cellViewModal?.infoValue
        if let contactKey: ContactKeys = cellViewModal?.contactKey {
            switch contactKey {
            case .phoneNumber:
                self.infoValueTextField.keyboardType = .numberPad
                let numberToolbar: UIToolbar = UIToolbar()
                numberToolbar.barStyle = UIBarStyle.default
                numberToolbar.items=[
                    UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
                    UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(numpadDonePressed))
                ]
                numberToolbar.sizeToFit()
                self.infoValueTextField.inputAccessoryView = numberToolbar
            case .email:
                self.infoValueTextField.keyboardType = .emailAddress
                self.infoValueTextField.inputAccessoryView = nil
            default:
                self.infoValueTextField.keyboardType = .alphabet
                self.infoValueTextField.inputAccessoryView = nil
            }
        }
    }
    
    @objc private func numpadDonePressed() {
        self.cellViewModal?.updateValue(updatedValue: self.infoValueTextField.text)
        self.infoValueTextField.resignFirstResponder()
    }
    
}

extension EditContactOtherInfoTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.cellViewModal?.updateValue(updatedValue: textField.text)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.acknowledgementDelegate?.textFieldInCellBecameActive(cell: self)

    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.acknowledgementDelegate?.textFieldInCellBecameInactive(cell: self)
        return true
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension EditContactOtherInfoTableViewCell: KeyboardDisplayer {
    
    func resignKeyboardResponder() {
        self.infoValueTextField.resignFirstResponder()
    }
    
    func activateKeyboardResponder() {
        self.infoValueTextField.becomeFirstResponder()
    }
}
