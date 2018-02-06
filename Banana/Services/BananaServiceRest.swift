//
//  BananaServiceRest.swift
//  Banana
//
//  Created by TQM on 10/10/17.
//  Copyright © 2017 Minh Tran. All rights reserved.
//

import Bolts

class BananaServiceRest: BaseService, BananaServiceProtocol {

    func Register(param: Dictionary<String, Any>) -> BFTask<AnyObject> {
        return self.makeRequest(request: BananaRouter.Register(param: param), returnType: RegisterResponse.self, isArrayResponse: false, showLoading: true).task
    }
    func GetEventList(userID: String) -> BFTask<AnyObject> {
        return self.makeRequest(request: BananaRouter.GetEventList(userID: userID), returnType: EventListResponse.self, isArrayResponse: false, showLoading: true).task
    }
    
    func GetEvent(eventID: String) -> BFTask<AnyObject> {
        return self.makeRequest(request: BananaRouter.GetEvent(eventID: eventID), returnType: EventDetailsResponse.self, isArrayResponse: false, showLoading: true).task
    }
    
    func Login(param: Dictionary<String, Any>) -> BFTask<AnyObject> {
        return self.makeRequest(request: BananaRouter.Login(param: param), returnType: LoginResponse.self, isArrayResponse: false, showLoading: true).task
    }
    
    func PostEvent(param: Dictionary<String, Any>,token: String) -> BFTask<AnyObject> {
        return self.makeRequest(request: BananaRouter.PostEvent(param: param,token: token), returnType: PostEventResponse.self, isArrayResponse: false, showLoading: true).task
        
    }
    
    func UpdateUser(param: Dictionary<String, Any>,token: String,userID: String) -> BFTask<AnyObject> {
        return self.makeRequest(request: BananaRouter.UpdateUser(param: param,token: token,userID: userID), returnType: UpdateUserResponse.self, isArrayResponse: false, showLoading: true).task
    }
    
    func UpdatePassword(param: Dictionary<String, Any>,token: String,userID: String) -> BFTask<AnyObject> {
        return self.makeRequest(request: BananaRouter.UpdatePassword(param: param,token: token,userID: userID), returnType: UpdatePasswordResponse.self, isArrayResponse: false, showLoading: true).task
    }
    
    func UpvoteEvent(eventID: String,token: String) -> BFTask<AnyObject> {
        return self.makeRequest(request: BananaRouter.UpvoteEvent(eventID: eventID, token: token), returnType: UpvoteEventResponse.self, isArrayResponse: false, showLoading: true).task
    }
    
    func DownvoteEvent(eventID: String,token: String) -> BFTask<AnyObject> {
        return self.makeRequest(request: BananaRouter.DownvoteEvent(eventID: eventID, token: token), returnType: DownvoteEventResponse.self, isArrayResponse: false, showLoading: true).task
    }
    
    func GetLeaderboardAllTime() -> BFTask<AnyObject> {
        return self.makeRequest(request: BananaRouter.GetLeaderboardAllTime(), returnType: GetLeaderBoardResponse.self, isArrayResponse: false, showLoading: true).task
    }
    
    func GetLeaderboardMonth(time: String) -> BFTask<AnyObject> {
        return self.makeRequest(request: BananaRouter.GetLeaderboardMonth(time: time), returnType: GetLeaderBoardResponse.self, isArrayResponse: false, showLoading: true).task
    }
    
    func GetLeaderboardYear(time: String) -> BFTask<AnyObject> {
        return self.makeRequest(request: BananaRouter.GetLeaderboardYear(time: time), returnType: GetLeaderBoardResponse.self, isArrayResponse: false, showLoading: true).task
    }
    
    func GetUser(userID: String,token: String) -> BFTask<AnyObject> {
        return self.makeRequest(request: BananaRouter.GetUser(userID: userID,token: token), returnType: GetUserResponse.self, isArrayResponse: false, showLoading: true).task
    }
    
}

