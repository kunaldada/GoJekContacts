//
//  ViewController.swift
//  GoJekContacts
//
//  Created by ioshellboy on 12/06/19.
//  Copyright © 2019 ioshellboy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var dummyImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchImage()
        // Do any additional setup after loading the view.
    }

    func fetchData() {
        let dataFetcher = DataFetcher.shared
        let urlObject = URLObject(urlString: "https://gojek-contacts-app.herokuapp.com/contacts/5658.json", classToMap: nil, dataRequestType: .get)
        dataFetcher.fetchData(dataRequestor: urlObject, success: { (response: DummyModal?) -> (Void) in
            
        }) { (error) -> (Void) in
            
        }
    }

    func fetchImage() {
        let dataFetcher = DataFetcher.shared
        let urlObject = URLObject(urlString: "https://contacts-app.s3-ap-southeast-1.amazonaws.com/contacts/profile_pics/000/000/007/original/ab.jpg?1464516610", classToMap: nil, dataRequestType: .get)
        dataFetcher.fetchImage(dataRequestor: urlObject, success: { (image) -> (Void) in
            self.dummyImage.image = image
        }) { (error) -> (Void) in
            
        }
    }
    
}

