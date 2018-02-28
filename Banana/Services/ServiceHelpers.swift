//
//  ServiceHelpers.swift
//  Banana
//
//  Created by TQM on 10/13/17.
//  Copyright © 2017 Minh Tran. All rights reserved.
//

import UIKit
import Foundation

class ServiceHelpers: BaseServiceHelper {
    
    static func getEventList(userID: String,callback: @escaping (_ result: EventListResponse) -> Void) {
        let request = Helpers.getAssemblerResolver().resolve(BananaServiceProtocol.self)?.GetEventList(userID: userID)
        ServiceHelpers.handleBFTask(task: request!) { (data, err) in
            if err == nil {
                let res = data.result as! EventListResponse
                callback(res)
            }
        }
    }
    
    static func getEvent(eventID: String, callback: @escaping (_ result: EventDetailsResponse) -> Void) {
        let request = Helpers.getAssemblerResolver().resolve(BananaServiceProtocol.self)?.GetEvent(eventID: eventID)
        ServiceHelpers.handleBFTask(task: request!) { (data, err) in
            if err == nil {
                let res = data.result as! EventDetailsResponse
                callback(res)
            }
        }
    }
    
    static func register(param: Dictionary<String, Any>, callback: @escaping (_ result: RegisterResponse) -> Void) {
        let request = Helpers.getAssemblerResolver().resolve(BananaServiceProtocol.self)?.Register(param: param)
        ServiceHelpers.handleBFTask(task: request!) { (data, err) in
            if err == nil {
                let res = data.result as! RegisterResponse
                callback(res)
            }
        }
    }
    
    static func postEvent(param: Dictionary<String, Any>,token: String, callback: @escaping (_ result: PostEventResponse) -> Void) {
        let request = Helpers.getAssemblerResolver().resolve(BananaServiceProtocol.self)?.PostEvent(param: param,token: token)
        ServiceHelpers.handleBFTask(task: request!) { (data, err) in
            if err == nil {
                let res = data.result as! PostEventResponse
                callback(res)
            }
        }
    }

    static func login(param: Dictionary<String, Any>, callback: @escaping (_ result: LoginResponse) -> Void) {
        let request = Helpers.getAssemblerResolver().resolve(BananaServiceProtocol.self)?.Login(param: param)
        ServiceHelpers.handleBFTask(task: request!) { (data, err) in
            if err == nil {
                let res = data.result as! LoginResponse
                callback(res)
            }
        }
    }
    
    static func updateUser(param: Dictionary<String, Any>,token: String,userID: String, callback: @escaping (_ result: UpdateUserResponse) -> Void) {
        let request = Helpers.getAssemblerResolver().resolve(BananaServiceProtocol.self)?.UpdateUser(param: param, token: token,userID: userID)
        ServiceHelpers.handleBFTask(task: request!) { (data, err) in
            if err == nil {
                let res = data.result as! UpdateUserResponse
                callback(res)
            }
        }
    }
    
    static func updatePassword(param: Dictionary<String, Any>,token: String,userID: String, callback: @escaping (_ result: UpdatePasswordResponse) -> Void) {
        let request = Helpers.getAssemblerResolver().resolve(BananaServiceProtocol.self)?.UpdatePassword(param: param, token: token,userID: userID)
        ServiceHelpers.handleBFTask(task: request!) { (data, err) in
            if err == nil {
                let res = data.result as! UpdatePasswordResponse
                callback(res)
            }
        }
    }
    
    static func upvoteEvent(param: Dictionary<String, Any>, eventID: String,token: String, callback: @escaping (_ result: UpvoteEventResponse) -> Void) {
        let request = Helpers.getAssemblerResolver().resolve(BananaServiceProtocol.self)?.UpvoteEvent(param: param, eventID: eventID, token: token)
        ServiceHelpers.handleBFTask(task: request!) { (data, err) in
            if err == nil {
                let res = data.result as! UpvoteEventResponse
                callback(res)
            }
        }
    }
    
    static func downvoteEvent(param: Dictionary<String, Any>, eventID: String,token: String, callback: @escaping (_ result: DownvoteEventResponse) -> Void) {
        let request = Helpers.getAssemblerResolver().resolve(BananaServiceProtocol.self)?.DownvoteEvent(param: param, eventID: eventID, token: token)
        ServiceHelpers.handleBFTask(task: request!) { (data, err) in
            if err == nil {
                let res = data.result as! DownvoteEventResponse
                callback(res)
            }
        }
    }
    
    static func getLeaderboardAllTime( callback: @escaping (_ result: GetLeaderBoardResponse) -> Void) {
        let request = Helpers.getAssemblerResolver().resolve(BananaServiceProtocol.self)?.GetLeaderboardAllTime()
        ServiceHelpers.handleBFTask(task: request!) { (data, err) in
            if err == nil {
                let res = data.result as! GetLeaderBoardResponse
                callback(res)
            }
        }
    }
    
    static func getLeaderboardMonth(time: String, callback: @escaping (_ result: GetLeaderBoardResponse) -> Void) {
        let request = Helpers.getAssemblerResolver().resolve(BananaServiceProtocol.self)?.GetLeaderboardMonth(time: time)
        ServiceHelpers.handleBFTask(task: request!) { (data, err) in
            if err == nil {
                let res = data.result as! GetLeaderBoardResponse
                callback(res)
            }
        }
    }
    
    static func getLeaderboardYear(time: String, callback: @escaping (_ result: GetLeaderBoardResponse) -> Void) {
        let request = Helpers.getAssemblerResolver().resolve(BananaServiceProtocol.self)?.GetLeaderboardYear(time: time)
        ServiceHelpers.handleBFTask(task: request!) { (data, err) in
            if err == nil {
                let res = data.result as! GetLeaderBoardResponse
                callback(res)
            }
        }
    }
    
    static func getUser(userID: String,token: String, callback: @escaping (_ result: GetUserResponse) -> Void) {
        let request = Helpers.getAssemblerResolver().resolve(BananaServiceProtocol.self)?.GetUser(userID: userID, token: token)
        ServiceHelpers.handleBFTask(task: request!) { (data, err) in
            if err == nil {
                let res = data.result as! GetUserResponse
                callback(res)
            }
        }
    }
    
}
