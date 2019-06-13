//
//  ContactDetailProfileTableViewCell.swift
//  GoJekContacts
//
//  Created by ioshellboy on 13/06/19.
//  Copyright © 2019 ioshellboy. All rights reserved.
//

import UIKit

class ContactDetailProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
