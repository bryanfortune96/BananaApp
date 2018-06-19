//
//  ObjectMapper.swift
//  Banana
//
//  Created by TQM on 10/10/17.
//  Copyright © 2017 Minh Tran. All rights reserved.
//

import ObjectMapper


class EventListResponse: BaseResponse {
    var data : [EventDetailsObject]?
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map["data"]
    }
}

class EventDetailsResponse: BaseResponse {
    var data : EventDetailsObject?
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map["data"]
    }
}

class LoginResponse: BaseResponse {
    var data: UserInfoObject?
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map["data"]
    }
}

class PostEventResponse: BaseResponse {
    var data: EventDetailsObject?
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map["data"]
    }
}

class RegisterResponse: BaseResponse {
    var data: RegisterObject?
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map["data"]
    }
}

class UpdateUserResponse: BaseResponse {
    var data: UserUpdateObject?
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map["data"]
    }
}

class UpdatePasswordResponse: BaseResponse {
    override func mapping(map: Map) {
        super.mapping(map: map)
    }
}

class UpvoteEventResponse: BaseResponse {
    var data: VoteResponseObject?
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map["data"]
    }
}

class DownvoteEventResponse: BaseResponse {
    var data: VoteResponseObject?
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map["data"]
    }
}

class GetLeaderBoardResponse: BaseResponse {
    var data: [UsersObject]?
    override func mapping(map: Map)  {
        super.mapping(map: map)
        data <- map["data"]
    }
}

class GetUserResponse: BaseResponse {
    var data: UsersObject?
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map["data"]
    }
}

class VoteResponseObject: NSObject, Mappable {
    var point: PointsObject?
    var eventId: String?
    var authorId: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        point <- map["Point"]
        authorId <- map["userId"]
        eventId <- map["_id"]
    }
}


class UsersObject: NSObject, Mappable {
    
    var id: String?
    var email: String?
    var point: Int?
    var level: Int?
    var phone: String?
    var address: String?
    var nickname: String?
    var date: String?
    var queryPoint: Int?
    var avatarImgPath: String? = ""
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["_id"]
        email <- map["email"]
        point <- map["reputation"]
        level <- map["level"]
        phone <- map["phone"]
        address <- map["address"]
        nickname <- map["nickname"]
        date <- map["created_at"]
        queryPoint <- map["queryTimePoints"]
        avatarImgPath <- map["avatar"]
    }
}

class EventDetailsObject: NSObject, Mappable {
    
    var name: String?
    var author: UsersObject?
    var startLatitude: Float?
    var startLongtitude: Float?
    var endLatitude: Float?
    var endLongtitude: Float?
    var district: Int?
    var id: String?
    var isFlood: Bool?
    var isRecommended: Bool?
    var isAccident: Bool?
    var isRaining: Bool?
    var carSpeed: Int?
    var bikeSpeed: Int?
    var density: Int?
    var nextDensity: Int?
    var eventType: Int?
    var updatedAt: String?
    var createdAt: String?
    var point: PointsObject?
    var isUpvoted: Bool?
    var isDownvoted: Bool?
    var imagePaths: [String]?
    var votedScore: Double?
    
    public required init?(map: Map) {
        
    }
    
    public override init() {
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        author <- map["userId"]
        district <- map["district"]
        id <- map["_id"]
        isFlood <- map["has_flood"]
        isRecommended <- map["should_travel"]
        isAccident <- map["has_accident"]
        isRaining <- map["has_rain"]
        carSpeed <- map["car_speed"]
        bikeSpeed <- map["motorbike_speed"]
        density <- map["density"]
        nextDensity <- map["next_density"]
        eventType <- map["eventType"]
        updatedAt <- map["updated_at"]
        createdAt <- map["created_at"]
        point <- map["Point"]
        isUpvoted <- map["isUpvoted"]
        imagePaths <- map["mediaDatas"]
        startLatitude <- map["latitude"]
        votedScore <- map["votedScore"]
        startLongtitude <- map["longitude"]
        endLatitude <- map["end_latitude"]
        endLongtitude <- map["end_longitude"]
        
    }
}

class PointsObject: NSObject,Mappable {
    var votedUserIDs: [String] = []
    var points: Double?
    
    public required init?(map: Map) {
    }
    
    public override init() {
    }
    
    func mapping(map: Map) {
        points <- map["points"]
        votedUserIDs <- map["VotedUsers"]
    }
    
}

class UserInfoObject: NSObject, Mappable {
    var id: String?
    var userName: String?
    var phoneNo: String?
    var address: String?
    var token: String?
    
    public required init?(map: Map) {
        
    }
    
    public override init() {
    }
    
    func mapping(map: Map) {
        id <- map["_id"]
        userName <- map["nickname"]
        phoneNo <- map["phone"]
        address <- map["address"]
        token <- map["token"]
    }
    
}


class RegisterObject: NSObject, Mappable {
    var id: String?
    var userName: String?
    var phoneNo: String?
    var address: String?
    
    public required init?(map: Map) {
        
    }
    
    public override init() {
    }
    
    func mapping(map: Map) {
        id <- map["_id"]
        userName <- map["nickname"]
        phoneNo <- map["phone"]
        address <- map["address"]
    }
    
}

class UserUpdateObject: NSObject, Mappable {
    var id: String?
    var userName: String?
    var phoneNo: String?
    var address: String?
    var email: String?
    public required init?(map: Map) {
        
    }
    
    public override init() {
    }
    
    func mapping(map: Map) {
        id <- map["_id"]
        userName <- map["nickname"]
        phoneNo <- map["phone"]
        address <- map["address"]
        email <- map["email"]
    }
    
}








