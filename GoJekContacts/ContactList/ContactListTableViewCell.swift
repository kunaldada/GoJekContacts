//
//  ContactListTableViewCell.swift
//  GoJekContacts
//
//  Created by ioshellboy on 13/06/19.
//  Copyright © 2019 ioshellboy. All rights reserved.
//

import UIKit

class ContactListTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var favoriteImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height*0.5
        // Configure the view for the selected state
    }
    
    func bindData(cellViewModal: ContactListCellViewModalProtocol?) {
        guard let shortContact = cellViewModal?.shortContact else {return}
        self.titleLabel.text = shortContact.getFullName()
        let favImageName = shortContact.favorite ? "favourite_button_selected" : "favourite_button"
        self.favoriteImageView.image = UIImage(named: favImageName)
        
        let imageUrlObject = URLObject(urlString: shortContact.profilePic, dataRequestType: .get)
        DataFetcher.shared.fetchImage(dataRequestor: imageUrlObject, success: { (image) -> (Void) in
            self.profileImageView.image = image
        }, failure: nil)
    }
    
}
