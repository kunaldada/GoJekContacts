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
        self.favoriteImageView.image = UIImage(named: ImageStringConstants.homeFavImageName)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height*0.5
        // Configure the view for the selected state
    }
    
    func bindData(cellViewModal: ContactListCellViewModalProtocol?) {
        self.profileImageView.image = UIImage(named:ImageStringConstants.placeHolderImageName)
        
        guard let shortContact = cellViewModal?.shortContact else {return}
        self.titleLabel.text = shortContact.getFullName()

        favoriteImageView.isHidden = !shortContact.favorite
        
        guard let profilePicUrlStr: String = shortContact.profilePic,
            profilePicUrlStr.isValidUrl() else {return}

        let imageUrlObject = URLObject(urlString: profilePicUrlStr, dataRequestType: .get)
        DataFetcher.shared.fetchImage(dataRequestor: imageUrlObject, success: { (image) -> (Void) in
            self.profileImageView.image = image
        }, failure: nil)
    }
    
}

extension String {
    func isValidUrl() -> Bool {
        let urlRegEx = "^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        let result = urlTest.evaluate(with: self)
        return result
    }
}
