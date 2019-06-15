//
//  APIConnection.swift
//  GoJekContacts
//
//  Created by ioshellboy on 12/06/19.
//  Copyright © 2019 ioshellboy. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
final class APIConnection {
    
    
    private lazy var sessionManager = SessionManager(configuration:self.apiURLSessionConfiguration(),
                                                     serverTrustPolicyManager: nil)


    func apiURLSessionConfiguration() -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
//        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
//        configuration.requestCachePolicy = .useProtocolCachePolicy
//        configuration.allowsCellularAccess = true
        configuration.timeoutIntervalForRequest = 60
//        configuration.urlCache = self.apiURLCache()
        return configuration
    }

    func apiURLCache() -> URLCache {
        return URLCache(
            memoryCapacity: 0, // 0 MB
            diskCapacity: 0, // 0 MB
            diskPath: "com.gojek.apiUrlCache"
        )
    }
    
    func printAll(){
        print(sessionManager)
    }
    
    internal func makeConnection(dataRequestor: DataRequestorProtocol, completion:@escaping (_ data: Data?,_ error: Error?,_ statusCode: Int?)->(Void)) {
        guard let urlRequest = self.getURLRequest(dataRequestor: dataRequestor)
            else {return}
        
        self.sessionManager.request(urlRequest).response { (dataResponse) in
            
            let result: Result<Data> = Request.serializeResponseData(response: dataResponse.response, data: dataResponse.data, error: dataResponse.error)

            completion(result.value, result.error, dataResponse.response?.statusCode)
        }
        
    }
    
    func makeImageConnection(dataRequestor: DataRequestorProtocol, completion:@escaping (_ data: UIImage?,_ error: Error?,_ statusCode: Int?)->(Void)) {
        
        guard let urlRequest = self.getURLRequest(dataRequestor: dataRequestor)
            else {return}
        
        self.sessionManager.request(urlRequest).responseImage { (dataResponse) in
            completion(dataResponse.result.value as? UIImage, dataResponse.result.error, dataResponse.response?.statusCode)
        }

    }
    
    internal func getURLRequest(dataRequestor: DataRequestorProtocol) -> URLRequest? {
        
        guard let urlString = dataRequestor.urlString,
            let url = URL(string: urlString) else {return nil}
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = dataRequestor.dataRequestType.getAssociatedString
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let appendedParameters = dataRequestor.appendedParameters {
            let jsonData = try? JSONSerialization.data(withJSONObject: appendedParameters)
            request.httpBody = jsonData
        }
        return request
    }
    
}
