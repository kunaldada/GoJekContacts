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
    var gradientLayer: CAGradientLayer?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.profileImageView.layer.masksToBounds = true
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height*0.5
        self.profileImageView.layer.borderWidth = 3
        self.profileImageView.layer.borderColor = UIColor.white.cgColor
        
        self.profileImageView.layer.shadowRadius = 4.0
        self.profileImageView.contentMode = .scaleAspectFill
        self.gradientLayer = CAGradientLayer()
        self.gradientLayer?.colors = [UIColor.white.cgColor, ColorConstant.applicationColor.withAlphaComponent(0.1).cgColor]
        self.gradientLayer?.locations = [0.0 , 1.0]
        self.gradientLayer?.startPoint = CGPoint(x: 1.0, y: 0.0)
        self.gradientLayer?.endPoint = CGPoint(x: 1.0, y: 1.0)
        self.gradientLayer?.frame = self.contentView.frame
        self.contentView.layer.insertSublayer(self.gradientLayer!, at: 0)
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.gradientLayer?.frame = self.contentView.frame
    }

    func bindData(cellViewModal: ContactDetailProfileCellViewModal?) {
        self.cellViewModal = cellViewModal
        
        self.nameLabel.text = self.cellViewModal?.detailModal?.fullName
        
        self.emailButton.isUserInteractionEnabled = cellViewModal?.detailModal?.hasValidEmail ?? false
        let shouldShowMobile: Bool = cellViewModal?.detailModal?.hasValidMobile ?? false
        self.messageButton.isUserInteractionEnabled = shouldShowMobile
        self.callButton.isUserInteractionEnabled = shouldShowMobile
        
        let favoriteImageName = self.cellViewModal?.detailModal?.favoriteStatus == true ? ImageStringConstants.favSelectedImageName : ImageStringConstants.favUnselectedImageName
        self.favButton.setImage(UIImage(named: favoriteImageName), for: .normal)
        self.favButton.setImage(UIImage(named: favoriteImageName), for: .highlighted)

        self.profileImageView.image = UIImage(named:ImageStringConstants.placeHolderImageName)

        guard let profilePicUrlStr: String = self.cellViewModal?.detailModal?.profilePicUrlString,
            profilePicUrlStr.isValidUrl() else {return}
        
        let imageUrlObject = URLObject(urlString: profilePicUrlStr, dataRequestType: .get, appendedParameters: nil)
        DataFetcher.shared.fetchImage(dataRequestor: imageUrlObject, success: { (image, _) -> (Void) in
            self.profileImageView.image = image
        }, failure: nil)
        

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func messageButtonClicked(_ sender: Any) {
        self.cellViewModal?.messageSelected()
    }
    
    @IBAction func callButtonClicked(_ sender: Any) {
        self.cellViewModal?.callSelected()
    }
    
    @IBAction func emailButtonClicked(_ sender: Any) {
        self.cellViewModal?.emailSelected()
    }
    
    @IBAction func favoriteButtonClicked(_ sender: Any) {
        self.cellViewModal?.favoriteSelected()
    }
}
