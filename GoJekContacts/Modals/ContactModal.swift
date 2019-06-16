//
//  ContactModal.swift
//  GoJekContacts
//
//  Created by ioshellboy on 14/06/19.
//  Copyright © 2019 ioshellboy. All rights reserved.
//

import UIKit

struct ContactModal: Codable {
    let contactId: Int?
    let firstName: String?
    let lastName: String?
    let profilePic: String?
    let favorite: Bool?
    let email: String?
    let phoneNumber: String?
    let errors: [String]?
    
    private enum CodingKeys : String, CodingKey {
        case contactId = "id"
        case firstName = "first_name"
        case lastName = "last_name"
        case profilePic = "profile_pic"
        case favorite
        case email
        case phoneNumber = "phone_number"
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
