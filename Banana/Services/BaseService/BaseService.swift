//
//  BaseService.swift
//  Banana
//
//  Created by TQM on 10/13/17.
//  Copyright © 2017 Minh Tran. All rights reserved.
//

import UIKit
import Alamofire
import Bolts
import ObjectMapper

open class BaseService: NSObject, BaseServiceProtocol {
    public var errorDomain: String {
        return "\(type(of:self)).errorDomain"
    }
    
    func makeRequest<T>(request: URLRequestConvertible, returnType: T.Type, isArrayResponse: Bool, showLoading: Bool = true) -> MyRequest where T : Mappable {
        return self.doRequest(request: request, returnType: returnType, isArrayResponse: isArrayResponse,showLoading: showLoading)
    }
    
    func makeRequestWithFormData<T>(data: Data, param: [String: Any], request: URLRequestConvertible, returnType: T.Type, isArrayResponse: Bool, showLoading: Bool = true) -> MyRequest where T : Mappable {
        return self.doRequestWithDataForm(data: data, param: param, request: request, returnType: returnType, isArrayResponse: isArrayResponse)
    }
    
}

