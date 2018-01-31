//
//  AppDelegate.swift
//  Banana
//
//  Created by TQM on 9/8/17.
//  Copyright © 2017 Minh Tran. All rights reserved.
//

import UIKit
import RDVTabBarController
import GoogleMobileAds
import GoogleMaps
import GooglePlaces
import MBProgressHUD
import IQKeyboardManager


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var viewcontroller : UIViewController?
    var tabHome : UINavigationController?
    var tabList : UINavigationController?
    var tabSubmit : UINavigationController?
    var tabRank: UINavigationController?
    let assembler = ApplicationAssembler.sharedInstance
    var hub: MBProgressHUD?{
        didSet{
            hub?.mode = .indeterminate
            hub?.bezelView.color = UIColor.clear
            hub?.contentColor = Colors.appTintColor
        }
    }
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UserDefaults.standard.register(defaults: ["BitMask": 2])
        UserDefaults.standard.register(defaults: ["isLoggedIn": false])
        UserDefaults.standard.register(defaults: ["Email": ""])
        UserDefaults.standard.register(defaults: ["Password": ""])
        UserDefaults.standard.register(defaults: ["UserID": ""])
        UserDefaults.standard.register(defaults: ["Token": ""])
        UserDefaults.standard.register(defaults: ["UserName": ""])
        UserDefaults.standard.register(defaults: ["Phone": ""])
        UserDefaults.standard.register(defaults: ["Address": ""])


        //IQKeyboardManager.shared().isEnabled = true

        
        GMSServices.provideAPIKey(Strings.mapAPIKey)
        GMSPlacesClient.provideAPIKey(Strings.placesAPIKey)
        window = UIWindow.init(frame: UIScreen.main.bounds)
        loadVC()
        
        window?.rootViewController = self.viewcontroller
        window?.makeKeyAndVisible()
        
        let vc = LoginViewController()
        self.viewcontroller?.present(vc, animated: true, completion: nil)
        
        GADMobileAds.configure(withApplicationID: "ca-app-pub-1846184064173538~9738613200")
        
        // Override point for customization after application launch.

        return true
    }


    func loadVC(){
        let homeVC = HomeViewController()
        self.tabHome = UINavigationController.init(rootViewController: homeVC)
        
        let listVC = ListViewController()
        self.tabList = UINavigationController.init(rootViewController: listVC)
        
//        let submitVC = SubmitViewController()
//        self.tabSubmit = UINavigationController.init(rootViewController: submitVC)
        
        let rankVC = RankViewController()
        self.tabRank = UINavigationController.init(rootViewController: rankVC)
        
        let tabbarController = RDVTabBarController.init()
        
        self.viewcontroller = tabbarController
        
        tabbarController.viewControllers = [homeVC,listVC,rankVC]
       
        customTabbar(tabbarController: tabbarController)
        
    }
    
    func customTabbar(tabbarController: RDVTabBarController){
        let tabbar = tabbarController.tabBar
        tabbar?.backgroundView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 100, height: UIScreen.main.bounds.height)
        //tabbar?.isTranslucent = true
        //tabbar?.backgroundView.alpha = 0.7
        tabbar?.backgroundView.backgroundColor = UIColor.white
        tabbar?.setHeight(40)
        let items = tabbarController.tabBar.items
        let homeTab = items?[0] as! RDVTabBarItem
        homeTab.itemHeight = 40
        let listTab = items?[1] as! RDVTabBarItem
        listTab.itemHeight = 40
        
        let rankTab = items?[2] as! RDVTabBarItem
        rankTab.itemHeight = 40

        
        homeTab.setFinishedSelectedImage(#imageLiteral(resourceName: "nav_homeSelected_icon"), withFinishedUnselectedImage: #imageLiteral(resourceName: "nav_homeUnselected_icon"))
        listTab.setFinishedSelectedImage(#imageLiteral(resourceName: "nav_listSelected_icon"), withFinishedUnselectedImage: #imageLiteral(resourceName: "nav_listUnselected_icon"))
        rankTab.setFinishedSelectedImage(#imageLiteral(resourceName: "nav_rankSelected_icon"), withFinishedUnselectedImage: #imageLiteral(resourceName: "nav_rankUnselected_icon"))

        

    }
    
    func hideLoading(){
        if Thread.isMainThread {
            if self.hub != nil {
                self.hub?.hide(animated: false)
                self.hub = nil
            }
        }else{
            DispatchQueue.main.async {
                if self.hub != nil {
                    self.hub?.hide(animated: false)
                    self.hub = nil
                }
            }
        }
        
    }
    
    // Helper function to show and hide loading indication on top.
    func showLoading(){
        
        self.hideLoading()
        if Thread.isMainThread {
            self.hub = MBProgressHUD.showAdded(to: self.window!, animated: false)
        }else{
            DispatchQueue.main.async {
                self.hub = MBProgressHUD.showAdded(to: self.window!, animated: false)
            }
        }
    }

    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

