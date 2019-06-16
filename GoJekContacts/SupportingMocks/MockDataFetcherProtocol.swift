//
//  MockDataFetcherProtocol.swift
//  GoJekContacts
//
//  Created by ioshellboy on 15/06/19.
//  Copyright © 2019 ioshellboy. All rights reserved.
//

import UIKit

class MockDataFetcher: DataFetcherProtocol {
    
    
    var expectedDataResponse: (Codable?, Error?)?
    var expectedImageResponse: (UIImage?, Error?)?
    var updatedDataRequestor: DataRequestorProtocol?
    
    func fetchData<T: Codable>(dataRequestor: DataRequestorProtocol, success: ((_ response: T?) -> (Void))?, failure: ((_ error: Error?) -> (Void))?) {
        self.updatedDataRequestor = dataRequestor
        if let expectedResponse = self.expectedDataResponse?.0 {
            success?(expectedResponse as? T)
        }
        else if let error = self.expectedDataResponse?.1 {
            failure?(error)
        }
    }
    
    
    internal func fetchImage(dataRequestor: DataRequestorProtocol, success: ((_ response: UIImage?, _ requestUrlStr: String?) -> (Void))?, failure: ((_ error: Error?) -> (Void))?) {
        self.updatedDataRequestor = dataRequestor
        if let expectedResponse = self.expectedImageResponse?.0 {
            success?(expectedResponse, dataRequestor.urlString)
        }
        else if let error = self.expectedDataResponse?.1 {
            failure?(error)
        }
    }
    
    
}
