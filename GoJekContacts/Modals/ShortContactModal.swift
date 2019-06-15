//
//  ShortContactModal.swift
//  GoJekContacts
//
//  Created by ioshellboy on 13/06/19.
//  Copyright © 2019 ioshellboy. All rights reserved.
//

import UIKit

struct ShortContactModal: Codable {

    let contactId: Int?
    let firstName: String?
    let lastName: String?
    let profilePic: String?
    let favorite: Bool = false
    let url: String?
    let errors: [String]?
    
    var fullName: String? {
        return self.getFullName()
    }
    
    private enum CodingKeys : String, CodingKey {
        case contactId = "id"
        case firstName = "first_name"
        case lastName = "last_name"
        case profilePic = "profile_pic"
        case favorite
        case url
        case errors
    }
    
    internal func getFullName() -> String {
        var fullName = ""
        if let firstName = firstName {
            fullName = firstName
        }
        if let lastName = lastName {
            if fullName == "" {
                fullName = lastName
            }
            else {
                fullName = fullName + " " + lastName
            }
        }
        return fullName
    }
    
}
