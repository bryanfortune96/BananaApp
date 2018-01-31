//
//  Traffic Info.swift
//  Banana
//
//  Created by TQM on 9/13/17.
//  Copyright © 2017 Minh Tran. All rights reserved.
//

import UIKit

class TrafficInfo: NSObject {

    var title = ""
    var point = 0
    var time: NSDate?
    var userList:[Users] = []
    var density = 3
    var bikes = 1
    var cars = 1
    var isRaining = false
    var isFlooding = false
    var isAccidenting = false
    var isPikachu = false
    var isRecommended = false
    var area = ""
    var timeToEnd = 0
    var district = 0
    var longtitude = 0.0
    var latitude = 0.0
    
}

class District: NSObject {
    
    init(title: String, id: Int,isFavorite: Bool)
    {
        self.title = title
        self.id = id
        self.isFavorite = isFavorite
    }
    
    init(title: String, id: Int,popArea: String)
    {
        self.title = title
        self.id = id
        self.popArea = popArea

        
    }
    override init()
    {
        
    }
    var title = ""
    var id: Int?
    var isFavorite = false
    var popArea = ""
}

class Users: NSObject {
    
    init(title: String,point: Int,level: String)
    {
        self.title = title
        self.point = point
        self.level = level
    }
    var title = ""
    var point = 0
    var level = ""
    var imgPath = ""
    var userName = ""
    var address = ""
    var phoneNo = ""
    var isVolunteer = false
    var isAdmin = false
    var isBlacklisted = false
    var isTrusted = false
    
}









