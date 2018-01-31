//
//  BaseResponse.swift
//  Banana
//
//  Created by TQM on 10/10/17.
//  Copyright © 2017 Minh Tran. All rights reserved.
//

import ObjectMapper

class BaseResponse: NSObject, Mappable {
    var success: Bool?
    var message: String?
    //var token: String?
    public required init?(map: Map) {
    }
    
    public override init() {
    }
    
    func mapping(map: Map) {
        success <- map["success"]
        message   <- map["message"]
    }
}
