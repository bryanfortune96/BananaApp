//
//  APIRouter.swift
//  Banana
//
//  Created by TQM on 10/8/17.
//  Copyright © 2017 Minh Tran. All rights reserved.
//

import Alamofire
import ObjectMapper
let baseServerURL = "https://bananaserver.herokuapp.com/"


enum BananaRouter: URLRequestConvertible {
    
    case GetEventList(userID: String)
    case GetUser(userID: String,token: String)
    case PostUser(param: Dictionary<String, Any>)
    case Login(param: Dictionary<String, Any>)
    case GetEvent(eventID: String)
    case PostEvent(param: Dictionary<String, Any>,token: String)
    case Register(param: Dictionary<String, Any>)
    case UpdateUser(param: Dictionary<String,Any>,token: String,userID: String)
    case UpdatePassword(param: Dictionary<String,Any>,token: String,userID: String)
    case UpvoteEvent(param: Dictionary<String,Any>)
    case DownvoteEvent(param: Dictionary<String,Any>, eventID: String,token: String)
    case GetLeaderboardAllTime()
    case GetLeaderboardMonth(time: String)
    case GetLeaderboardYear(time: String)
    
    var method: Alamofire.HTTPMethod {
        
        switch self {
        case .GetEventList(let userID):
            return .get
        case .GetUser(let userID,let token):
            return .get
        case .PostUser(let param):
            return .post
        case .Login(let param):
            return .post
        case .GetEvent(let eventID):
            return .get
        case .PostEvent(let param,let token):
            return .post
        case .Register(let param):
            return .post
        case .UpdateUser(let param,let token,let userID):
            return .put
        case .UpdatePassword(let param,let token,let userID):
            return .put
        case .UpvoteEvent(let param):
            return .post
        case .DownvoteEvent(let param, let eventID,let token):
            return .post
        case .GetLeaderboardAllTime():
            return .get
        case .GetLeaderboardYear(let time):
            return .get
        case .GetLeaderboardMonth(let time):
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .GetEventList(let userID):
            return "eventsAll/\(userID)"
        case .GetUser(let userID,let token):
            return "user/\(userID)"
        case .PostUser(let param):
            return "user"
        case .Login(let param):
            return "user/login"
        case .GetEvent(let eventID):
            return "events/\(eventID)"
        case .PostEvent(let param,let token):
            return "events"
        case .Register(let param):
            return "user"
        case .UpdateUser(let param, let token,let userID):
            return "user/\(userID)"
        case .UpdatePassword(let param, let token,let userID):
            return "user/password/\(userID)"
        case .UpvoteEvent(let param):
            let eventID = param["eventId"] as! String
            return "events/upvote/\(eventID)"
        case .DownvoteEvent(let param, let eventID,let token):
            return "events/downvote/\(eventID)"
        case .GetLeaderboardAllTime():
            return "leaderboard"
        case .GetLeaderboardMonth(let time):
            return "leaderboard/month/\(time)"
        case .GetLeaderboardYear(let time):
            return "leaderboard/year/\(time)"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url:URL?
        //send params to url
        switch self {
        default:
            let string = "\(baseServerURL)\(path)"
            url = URL.init(string: string)
            //url = URL(string: (baseServerURL as NSString).appendingPathComponent(path))!
            break;
        }

        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        //send params to httpBody
        switch self {
            
        case .UpdateUser(let param, let token, let userID):
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: param, options: JSONSerialization.WritingOptions.prettyPrinted)
            break
        case .UpdatePassword(let param, let token, let userID):
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: param, options: JSONSerialization.WritingOptions.prettyPrinted)
            break
        case .PostUser(let param):
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: param, options: JSONSerialization.WritingOptions.prettyPrinted)
            break;
        case .Login(let param):
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: param, options: JSONSerialization.WritingOptions.prettyPrinted)
            break;
        case .PostEvent(let param, let token):
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: param, options: JSONSerialization.WritingOptions.prettyPrinted)
            break;
        case .Register(let param):
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: param, options: JSONSerialization.WritingOptions.prettyPrinted)
        case .UpvoteEvent(let param):
            let input = ["userId": param["userId"], "score": param["score"]]
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: param, options: JSONSerialization.WritingOptions.prettyPrinted)
        case .DownvoteEvent(let param, let eventID, let token):
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: param, options: JSONSerialization.WritingOptions.prettyPrinted)
        default:
            break;
        }
        
        //send header to httpHeader
        switch self {
        case .PostEvent(let param, let token):
            urlRequest.setValue(token, forHTTPHeaderField: "Authorization")
            break
        case .UpdatePassword(let param,let token, let userID):
            urlRequest.setValue(token, forHTTPHeaderField: "Authorization")
            break
        case .UpdateUser(let param,let token, let userID):
            urlRequest.setValue(token, forHTTPHeaderField: "Authorization")
        case .UpvoteEvent(let param):
            let token = param["token"] as? String
            urlRequest.setValue(token, forHTTPHeaderField: "Authorization")
        case .DownvoteEvent(let param, let eventID, let token):
            urlRequest.setValue(token, forHTTPHeaderField: "Authorization")
        case .GetUser(let userID, let token):
            urlRequest.setValue(token, forHTTPHeaderField: "Authorization")
        default:
            break
        }
        
        return urlRequest
    }
}
