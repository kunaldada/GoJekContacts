//
//  EditContactOtherInfoTableViewCell.swift
//  GoJekContacts
//
//  Created by ioshellboy on 15/06/19.
//  Copyright © 2019 ioshellboy. All rights reserved.
//

import UIKit

class EditContactOtherInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var infoKeyLabel: UILabel!
    @IBOutlet weak var infoValueTextField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindData(cellViewModal: AddEditContactOtherInfoCellViewModal?) {
        self.infoKeyLabel.text = cellViewModal?.displayKey
        self.infoValueTextField.text = cellViewModal?.infoValue
    }
}
