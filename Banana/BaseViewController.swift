//
//  BaseViewController.swift
//  Banana
//
//  Created by TQM on 9/9/17.
//  Copyright © 2017 Minh Tran. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class BaseViewController: UIViewController {
  
    
    var isOpeningMenu = false
    var titleList = ["Notification","Favorite Location","Our Facebook","Your thoughts","Your Reward","Help"]
    var iconList = [#imageLiteral(resourceName: "noti_icon"),#imageLiteral(resourceName: "favorite_icon"),#imageLiteral(resourceName: "page_icon"),#imageLiteral(resourceName: "idea_icon"),#imageLiteral(resourceName: "reward_icon"),#imageLiteral(resourceName: "help_icon")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //checkLogin()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    
}

extension BaseViewController: NVActivityIndicatorViewable {
    func showLoading() {
        let size = CGSize(width: 40, height: 40)
        startAnimating(size, message: "", type: NVActivityIndicatorType.pacman)
    }
    
    func hideLoading() {
        self.stopAnimating()
    }
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


