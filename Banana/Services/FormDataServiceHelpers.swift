//
//  formDataServiceHelpers.swift
//  Banana
//
//  Created by TQM on 2/6/18.
//  Copyright © 2018 Minh Tran. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

typealias Parameters = [String: String]

class FormDataServiceHelpers {
    static func postAvatar(data: Data, userID: String, token: String)  {
        var res = [String: Any]()
        let URL = "https://bananaserver.herokuapp.com/user/avatar/" + userID
        let request = try! URLRequest(url: URL, method: .put, headers: ["Content-Type": "application/x-www-form-urlencoded","Authorization": token])
    
        Alamofire.upload(multipartFormData: { MultipartFormData in
                let filename = "photo.jpeg"
                MultipartFormData.append(data, withName: "image", fileName: filename, mimeType: "image/jpeg")
        },
            with: request,
            encodingCompletion: { (result) in
                switch result {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        let value = response.result.value as! [String: Any]
                        print(value)
                        res = ["code": value["code"]!, "message": value["message"]!]
                        print(res)
                    }
                    
                case .failure( _):
                    res = ["code": -1, "message": "Could not connect to server"]
                }
        })
    }

    static func postImage(data: Data, eventID: String, token: String) {
        let URL = "https://bananaserver.herokuapp.com/events/media/" + eventID
        let request = try! URLRequest(url: URL, method: .put, headers: ["Content-Type": "application/x-www-form-urlencoded","Authorization": token])
        
        Alamofire.upload(multipartFormData: { MultipartFormData in
            let filename = eventID + ".jpeg"
            MultipartFormData.append(data, withName: "image", fileName: filename, mimeType: "image/jpeg")
        },
                         with: request,
                         encodingCompletion: { (result) in
                            switch result {
                            case .success(let upload, _, _):
                                upload.responseJSON { response in
                                    print(response.result.value!)
                                }
                                
                            case .failure(let encodingError):
                                print(encodingError)
                            }
        })
    }
}


