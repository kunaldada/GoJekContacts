//
//  ContactDetailProfileTableViewCell.swift
//  GoJekContacts
//
//  Created by ioshellboy on 13/06/19.
//  Copyright © 2019 ioshellboy. All rights reserved.
//

import UIKit

class ContactDetailProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    var cellViewModal: ContactDetailProfileCellViewModal?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func bindData(cellViewModal: ContactDetailProfileCellViewModal?) {
        self.cellViewModal = cellViewModal
        
        self.nameLabel.text = self.cellViewModal?.detailModal?.fullName
        
        self.profileImageView.image = UIImage(named:ImageStringConstants.placeHolderImageName)
        let imageUrlObject = URLObject(urlString: self.cellViewModal?.detailModal?.profilePicUrlString, dataRequestType: .get)
        DataFetcher.shared.fetchImage(dataRequestor: imageUrlObject, success: { (image) -> (Void) in
            self.profileImageView.image = image
        }, failure: nil)
        
        self.emailButton.isUserInteractionEnabled = cellViewModal?.detailModal?.hasValidEmail ?? false
        let shouldShowMobile: Bool = cellViewModal?.detailModal?.hasValidMobile ?? false
        self.messageButton.isUserInteractionEnabled = shouldShowMobile
        self.callButton.isUserInteractionEnabled = shouldShowMobile
        
        let favoriteImageName = self.cellViewModal?.detailModal?.favoriteStatus == true ? ImageStringConstants.favSelectedImageName : ImageStringConstants.favUnselectedImageName
        self.favButton.setImage(UIImage(named: favoriteImageName), for: .normal)
        self.favButton.setImage(UIImage(named: favoriteImageName), for: .highlighted)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func messageButtonClicked(_ sender: Any) {
        
    }
    
    @IBAction func callButtonClicked(_ sender: Any) {
        
    }
    
    @IBAction func emailButtonClicked(_ sender: Any) {
        
    }
    
    @IBAction func favoriteButtonClicked(_ sender: Any) {
        
    }
}
