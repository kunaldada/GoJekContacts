//
//  URLObject.swift
//  GoJekContacts
//
//  Created by ioshellboy on 12/06/19.
//  Copyright © 2019 ioshellboy. All rights reserved.
//

import UIKit


struct URLObject: DataRequestorProtocol {
    var urlString: String?
//    var classToMap: Codable?
    var dataRequestType: DataRequestType = .get
    var appendedParameters: [String: String]?
}
