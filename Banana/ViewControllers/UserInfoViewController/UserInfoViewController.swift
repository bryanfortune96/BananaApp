//
//  UserInfoViewController.swift
//  Banana
//
//  Created by TQM on 11/16/17.
//  Copyright © 2017 Minh Tran. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController {

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var avatarImgView: UIImageView!
    @IBOutlet weak var usrnameLb: UILabel!
    @IBOutlet weak var rankLb: UILabel!
    @IBOutlet weak var pointsLb: UILabel!
    @IBOutlet weak var dateLb: UILabel!
    @IBOutlet weak var constraint: NSLayoutConstraint!
    @IBOutlet weak var rankView: UIView!
    @IBOutlet weak var pointsView: UIView!
    @IBOutlet weak var dateView: UIView!
    
    
    var userInfo: UsersObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView()
    {
        // corner radius
        middleView.layer.cornerRadius = 10
        shadowView.layer.cornerRadius = 10
        rankView.layer.cornerRadius = 10
        dateView.layer.cornerRadius = 10
        pointsView.layer.cornerRadius = 10
        
        // shadow
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 3, height: 3)
        shadowView.layer.shadowOpacity = 0.7
        shadowView.layer.shadowRadius = 10
        
        //imageview rounded shape
        avatarImgView.clipsToBounds = true
        avatarImgView.layer.cornerRadius = 120.0/2
    

    }
    
    func loadData()
    {
        avatarImgView.image = #imageLiteral(resourceName: "user")
        if userInfo?.nickname != ""
        {
            usrnameLb.text = userInfo?.nickname
        }
        else{
            usrnameLb.text = userInfo?.email
        }
        
        rankLb.text = DataMgr.shared.levels[(userInfo?.level)!]
        pointsLb.text = "\(String(describing: (userInfo?.point)!)) points"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: (userInfo?.date)!)
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date!)
        let month = calendar.component(.month, from: date!)
        
        dateLb.text = "\(month)/\(year)"
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
