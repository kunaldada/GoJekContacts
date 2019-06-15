//
//  DataFetcher.swift
//  GoJekContacts
//
//  Created by ioshellboy on 12/06/19.
//  Copyright © 2019 ioshellboy. All rights reserved.
//

import UIKit

enum DataRequestType {
    case get, post, put
    
    var getAssociatedString: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .put:
            return "PUT"
        }
    }
}

protocol DataRequestorProtocol {
    var urlString: String? {get set}
//    var classToMap: Codable? {get set}
    var dataRequestType: DataRequestType {get set}
    var appendedParameters: [String: String]? {get set}
}

final class DataFetcher {
    
    static let shared = DataFetcher()
    
    private init() {
        
    }
    
    private let apiConnection = APIConnection()
    
    internal func fetchData<T: Codable>(dataRequestor: DataRequestorProtocol, success: ((_ response: T?) -> (Void))?, failure: ((_ error: Error?) -> (Void))?) {
        apiConnection.makeConnection(dataRequestor: dataRequestor) { (data, error, statusCode) -> (Void) in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let decodedResponse = try decoder.decode(T.self, from: data)
                    success?(decodedResponse)
                }
                catch{
                    failure?(error)
                }
            }
            else if let error = error {
                failure?(error)
            }
            else {
                failure?(nil)
            }
        }
        
    }
    
    internal func fetchImage(dataRequestor: DataRequestorProtocol, success: ((_ response: UIImage?) -> (Void))?, failure: ((_ error: Error?) -> (Void))?) {
        apiConnection.makeImageConnection(dataRequestor: dataRequestor) { (image, error, statusCode) -> (Void) in
            if let image = image {
                success?(image)
            }
            else if let error = error {
                failure?(error)
            }
            else {
                failure?(nil)
            }
        }
        
    }
}
