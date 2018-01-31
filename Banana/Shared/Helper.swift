//
//  Helper.swift
//  Banana
//
//  Created by TQM on 9/22/17.
//  Copyright © 2017 Minh Tran. All rights reserved.
//

import Foundation
import UIKit
import Swinject
import SCLAlertView
import AVFoundation

class Helpers:NSObject
{
    static var alert: SCLAlertViewResponder? = nil
    
    static var player: AVAudioPlayer?
    
    
    /// play sound with word
    ///
    /// - Parameters:
    ///   - word: word
    ///   - url: string
    static func playAudioWithURL(word: String, url: String) {
        // check file if it is exist or not
        // if yes => play
        // if no => download and save to local
        if let audioUrl = URL(string: url) {
            // create your document folder url
            let documentsUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            // your destination file url
            let fileName = "\(word)_\(audioUrl.lastPathComponent)"
            let destination = documentsUrl.appendingPathComponent(fileName)
            print(destination)
            
            if FileManager().fileExists(atPath: destination.path) {
                print("The file already exists at path")
                // play video
                Helpers.playAudioWithPath(path: destination)
            } else {
                //  if the file doesn't exist
                //  just download the data from your url
                Helpers.appDelegateInstance().showLoading()
                URLSession.shared.downloadTask(with: audioUrl, completionHandler: { (location, response, error) in
                    // after downloading your data you need to save it to your destination url
                    guard
                        let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                        let location = location, error == nil
                        else { return }
                    do {
                        try FileManager.default.moveItem(at: location, to: destination)
                        print("file saved")
                        
                        // playvideo
                        Helpers.playAudioWithPath(path: destination)
                    } catch {
                        print(error)
                    }
                }).resume()
            }
        }
        
    }
    
    
    /// Play video with path - local video
    ///
    /// - Parameter path: video path
    static func playAudioWithPath(path: URL) {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch let error as NSError {
            print(error.description)
        }
        do {
            try session.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
        } catch _ {
        }
        
        do{
            player = try AVAudioPlayer(contentsOf: path)
            player?.prepareToPlay()
            player?.volume = 1.0
            player?.play()
            Helpers.appDelegateInstance().hideLoading()
            
        }catch {
            print("Cant Play!)")
        }
        
    }
    
    /// Get current app delegate
    ///
    /// - Returns: AppDelegate instance
    static func appDelegateInstance() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    static func getAssemblerResolver() -> Resolver {
        return appDelegateInstance().assembler.resolver
    }
    
    /// Show wanring alert
    ///
    /// - Parameters:
    ///   - message: message you want to Show
    ///   - title: Title you want to show - it is app name by default
    static func showWarningAlert(message: String, title: String = Strings.appName) {
        alert?.close()
        alert = SCLAlertView().showWarning(title, subTitle: message)
    }
    
    /// show error alert
    ///
    /// - Parameters:
    ///   - message: message you want to show
    ///   - title: title you want to show, by default it is app name
    static func showErrorAlert(message: String, title: String = Strings.appName) {
        alert?.close()
        alert = SCLAlertView().showError(title, subTitle: message)
    }
    
    /// show success alert
    ///
    /// - Parameters:
    ///   - message: message you want to show
    ///   - title: title you want to show, by default it is app name
    static func showSuccessfulAlert(message: String, title: String = Strings.appName) {
        alert?.close()
        alert = SCLAlertView().showSuccess(title, subTitle: message)
    }
    
    
    //MARK: - Static function to get top viewcontroller
    static func topVC () -> UIViewController? {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }
    
    static func timeAgoSinceDate(date:NSDate, numericDates:Bool) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = NSDate()
        let earliest = now.earlierDate(date as Date)
        let latest = (earliest == now as Date) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest as Date,  to: latest as Date)
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
        
    }
}
