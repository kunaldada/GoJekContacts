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
    var gradientLayer: CAGradientLayer?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.profileImageView.layer.masksToBounds = true
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height*0.5
        self.profileImageView.layer.borderWidth = 3
        self.profileImageView.layer.borderColor = UIColor.white.cgColor
        
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindData(cellViewModal: AddEditContactProfileCellViewModal?) {
        
        self.profileImageView.image = UIImage(named:ImageStringConstants.placeHolderImageName)
        
        guard let profilePicUrlStr: String = cellViewModal?.infoValue,
            profilePicUrlStr.isValidUrl() else {return}
        
        let imageUrlObject = URLObject(urlString: profilePicUrlStr, dataRequestType: .get, appendedParameters: nil)
        DataFetcher.shared.fetchImage(dataRequestor: imageUrlObject, success: { (image, _) -> (Void) in
            self.profileImageView.image = image
        }, failure: nil)

    }
}
