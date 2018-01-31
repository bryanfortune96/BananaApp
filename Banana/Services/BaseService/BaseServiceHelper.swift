//
//  BaseServiceHelper.swift
//  Banana
//
//  Created by TQM on 10/13/17.
//  Copyright © 2017 Minh Tran. All rights reserved.
//

import Foundation
import Bolts
import Alamofire

class BaseServiceHelper: NSObject {
    static func handleError(_ error: NSError?) {
        guard let error = error else { return }
        if error.code == 401 { // task cancel
            return
        }
        print("Error code: \(error.code)")
        print("Error description: \(error.localizedDescription)")
        Helpers.showErrorAlert(message: error.localizedDescription)
    }
    
    static func handleBFTask (task: BFTask<AnyObject>, callback: @escaping ( _ result: BFTask<AnyObject>, _ error: NSError?) -> Void) {
        task.continue({ (t) -> Any? in
            if t.error != nil {
                let code = (t.error! as NSError).code
                if code == 401 {
                    print("Error code: 401")
                    return nil
                }else{
                    BaseServiceHelper.handleError(t.error as NSError?)
                }
                
                
            }
            callback(t, t.error as NSError?)
            return nil
        })
    }
    
    
    /// Cancel all current tasks
    static func cancelAllTasks() {
        let sessionManager = Alamofire.SessionManager.default
        sessionManager.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            dataTasks.forEach { $0.cancel() }
            uploadTasks.forEach { $0.cancel() }
            downloadTasks.forEach { $0.cancel() }
        }
    }
    
    
}
