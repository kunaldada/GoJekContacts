//
//  ContactDetailInfoTableViewCell.swift
//  GoJekContacts
//
//  Created by ioshellboy on 13/06/19.
//  Copyright © 2019 ioshellboy. All rights reserved.
//

import UIKit

class ContactDetailInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var infoKeyLabel: UILabel!
    @IBOutlet weak var infoValueLabel: UILabel!
    var cellViewModal: ContactDetailInfoCellViewModal?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindData(cellViewModal: ContactDetailInfoCellViewModal?) {
        self.cellViewModal = cellViewModal
        self.infoKeyLabel.text = cellViewModal?.infoKey
        self.infoValueLabel.text = cellViewModal?.infoValue
    }
}
