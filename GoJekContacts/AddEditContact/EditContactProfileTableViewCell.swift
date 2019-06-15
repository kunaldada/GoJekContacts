//
//  EditContactProfileTableViewCell.swift
//  GoJekContacts
//
//  Created by ioshellboy on 15/06/19.
//  Copyright © 2019 ioshellboy. All rights reserved.
//

import UIKit

class EditContactProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindData(cellViewModal: AddEditContactProfileCellViewModal?) {
        
        self.profileImageView.image = UIImage(named:ImageStringConstants.placeHolderImageName)
        
        guard let profilePicUrlStr: String = cellViewModal?.infoValue,
            profilePicUrlStr.isValidUrl() else {return}
        
        let imageUrlObject = URLObject(urlString: profilePicUrlStr, dataRequestType: .get)
        DataFetcher.shared.fetchImage(dataRequestor: imageUrlObject, success: { (image) -> (Void) in
            self.profileImageView.image = image
        }, failure: nil)

    }
}
