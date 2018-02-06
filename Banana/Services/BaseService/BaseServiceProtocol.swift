//
//  BaseServiceProtocol.swift
//  Banana
//
//  Created by TQM on 10/13/17.
//  Copyright © 2017 Minh Tran. All rights reserved.
//

import UIKit
import Alamofire
import Bolts
import ObjectMapper

public struct MyRequest {
    let task : BFTask<AnyObject>
    let request: Request
}
public protocol BaseServiceProtocol {
    var errorDomain : String {get}
    func error(code: Int, message : String) -> NSError
    func doRequest<T>(request: URLRequestConvertible, returnType: T.Type, isArrayResponse: Bool, showLoading: Bool) -> MyRequest where T : Mappable
}

extension BaseServiceProtocol {
    public func error(code: Int, message : String) -> NSError {
        return NSError(domain: self.errorDomain, code: code, userInfo: [NSLocalizedDescriptionKey : message])
    }
    
    //MARK: - Default Implementation
    public func doRequest<T>(request: URLRequestConvertible, returnType: T.Type, isArrayResponse: Bool, showLoading: Bool = true) -> MyRequest where T: Mappable  {
        
        let taskCompletionSource = BFTaskCompletionSource<AnyObject>()
        // we show loading if needed
        if showLoading == true{
            //Helpers.appDelegateInstance().showLoading()
        }
        print(request)
        
        let request = Alamofire.request(request).responseJSON { (response) in
            
            // we hide loading indicator if needed
            if showLoading == true {
                //Helpers.appDelegateInstance().hideLoading()
            }
            switch response.result {
            case .failure(_):
                let customError = NSError(domain: "bananaserver.herokuapp.com", code: response.response?.statusCode ?? 9901, userInfo: [NSLocalizedDescriptionKey: response.response?.description ?? "Could not connect to the server."])
                taskCompletionSource.setError(customError)
            case .success(let responseObject):
                print("=====request=====")
                print(request.urlRequest?.url?.absoluteString ?? "")
                print("=====response=====")
                print(responseObject)
                
                if response.response?.statusCode == 200 {
                    if isArrayResponse {
                        if let apiResponse = Mapper<T>().mapArray(JSONObject: responseObject) {
                            taskCompletionSource.setResult(apiResponse as AnyObject?)
                        }
                    } else {
                        if let apiResponse = Mapper<T>().map(JSONObject: responseObject) {
                            taskCompletionSource.setResult(apiResponse as AnyObject?)
                        }
                    }
                    
                } else {
                    let customError = NSError(domain: "techlove.vn", code: response.response?.statusCode ?? 9901, userInfo: [NSLocalizedDescriptionKey: response.response?.description ?? "Could not connect to the server."])
                    taskCompletionSource.setError(customError)
                    
                }
            }
        }
        
        return MyRequest(task: taskCompletionSource.task, request: request)
        
        
    }
    
    public func doRequestWithDataForm<T>(data: Data, param: [String: Any], request: URLRequestConvertible, returnType: T.Type, isArrayResponse: Bool, showLoading: Bool = true) -> MyRequest where T: Mappable  {
        
        let taskCompletionSource = BFTaskCompletionSource<AnyObject>()
        // we show loading if needed
        if showLoading == true{
            //Helpers.appDelegateInstance().showLoading()
        }
        print(request)
        
        Alamofire.upload(multipartFormData: { MultipartFormData in
            for (key, value) in param {
                MultipartFormData.append(self.convertAnyToDataType(input: value), withName: key)
            }
            
            if data != Data() {
                let fileName = param["userId"] as? String
                MultipartFormData.append(data, withName: "image", fileName: fileName!, mimeType: "image/jpeg")
            }
            
            
        }, with: request, encodingCompletion: { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print(response.result.value)
                }
                
            case .failure(let encodingError): break
            print(encodingError)
            }
    
        })
        
//        let request = Alamofire.request(request).responseJSON { (response) in
//
//            // we hide loading indicator if needed
//            if showLoading == true{
//                //Helpers.appDelegateInstance().hideLoading()
//            }
//            switch response.result {
//            case .failure(_):
//                let customError = NSError(domain: "bananaserver.herokuapp.com", code: response.response?.statusCode ?? 9901, userInfo: [NSLocalizedDescriptionKey: response.response?.description ?? "Could not connect to the server."])
//                taskCompletionSource.setError(customError)
//            case .success(let responseObject):
//                print("=====request=====")
//                print(request.urlRequest?.url?.absoluteString ?? "")
//                print("=====response=====")
//                print(responseObject)
//
//                if response.response?.statusCode == 200 {
//                    if isArrayResponse {
//                        if let apiResponse = Mapper<T>().mapArray(JSONObject: responseObject) {
//                            taskCompletionSource.setResult(apiResponse as AnyObject?)
//                        }
//                    } else {
//                        if let apiResponse = Mapper<T>().map(JSONObject: responseObject) {
//                            taskCompletionSource.setResult(apiResponse as AnyObject?)
//                        }
//                    }
//
//                } else {
//                    let customError = NSError(domain: "techlove.vn", code: response.response?.statusCode ?? 9901, userInfo: [NSLocalizedDescriptionKey: response.response?.description ?? "Could not connect to the server."])
//                    taskCompletionSource.setError(customError)
//
//                }
//            }
//        }
        
        return MyRequest(task: taskCompletionSource.task, request: request as! Request)
        
        
    }
    
    func convertAnyToDataType(input: Any) -> Data {
        var result = Data()
        switch input {
        case is Int:
            result = NSData(bytes: input as? UnsafeRawPointer, length: MemoryLayout<Int>.size) as Data
        case is Float:
            result = NSData(bytes: input as? UnsafeRawPointer, length: MemoryLayout<Float>.size) as Data
        case is Bool:
            result = NSData(bytes: input as? UnsafeRawPointer, length: MemoryLayout<Bool>.size) as Data
        case is String:
            result = (input as! String).data(using: .utf8)!
        default:
            break
        }
        
        return result
        
    }
    
}
