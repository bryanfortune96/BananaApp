//
//  TrafficDetailsViewController.swift
//  Banana
//
//  Created by TQM on 9/22/17.
//  Copyright © 2017 Minh Tran. All rights reserved.
//

import UIKit
import MarqueeLabel
import GoogleMaps
import SDWebImage

let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height

class TrafficDetailsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var imageBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var downButt: UIButton!
    @IBOutlet weak var upButt: UIButton!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var titleLb: MarqueeLabel!
    @IBOutlet weak var timePointsLb: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var imageAvailable = false
    var trafficTitles = ["Số người đăng","Lưu lượng xe","Xe máy","Xe hơi","Mưa","Tai nạn","Ngập lụt","CSGT","Khuyến cáo"]
    var trafficInfo: EventDetailsObject?
    var trafficContents:[String] = []
    var upVoteResponse: UpvoteEventResponse? {
        didSet {
            if (upVoteResponse?.success)! {
                let point = (upVoteResponse?.data?.upvotes)! - (upVoteResponse?.data?.downvotes)!
                self.setupDate(point: point)            } else {
                //self.hideLoading()
                let alert = UIAlertController(title: "Warning!", message: upVoteResponse?.message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    var downVoteResponse: DownvoteEventResponse? {
        didSet {
            if (downVoteResponse?.success)! {
                let point = (downVoteResponse?.data?.upvotes)! - (downVoteResponse?.data?.downvotes)!
                self.setupDate(point: point)            } else {
                //self.hideLoading()
                let alert = UIAlertController(title: "Warning!", message: downVoteResponse?.message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialize()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func Initialize()
    {
        blackView.isHidden = true
        blackView.alpha = 0
        blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeImage)))
        
        imageBottomConstraint.constant = -SCREEN_HEIGHT
        imageHeight.constant = SCREEN_HEIGHT - 200
        
        if trafficInfo?.imagePaths?.count != 0 {
            imageView.sd_setImage(with: NSURL(string: (trafficInfo?.imagePaths![0])!)! as URL, completed: nil)
            imageAvailable = true
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TrafficDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "TrafficDetailsTableViewCell")
      
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"/* date_format_you_want_in_string from
         * http://userguide.icu-project.org/formatparse/datetime
         */
        
        let date = dateFormatter.date(from: (trafficInfo?.updatedAt)!)
        let point = (trafficInfo?.point?.upVotes)! - (trafficInfo?.point?.downVotes)!

        titleLb.text = "\((trafficInfo?.name)!)                     "
        timePointsLb.text = "\(Helpers.timeAgoSinceDate(date: date! as NSDate, numericDates: false)) | \(point) points"
        trafficContents = ["15", DataMgr.shared.density[(trafficInfo?.density)!], DataMgr.shared.movability[(trafficInfo?.bikeSpeed)!], DataMgr.shared.movability[(trafficInfo?.carSpeed)!], (trafficInfo?.isRaining)! ? "Có" : "Không", (trafficInfo?.isAccident)! ? "Có" : "Không", (trafficInfo?.isFlood)! ? "Có" : "Không", "Không", (trafficInfo?.isRecommended)! ? "Nên di chuyển" : "Không nên di chuyển"]
        
        // corner radius
        middleView.layer.cornerRadius = 10
        shadowView.layer.cornerRadius = 10
        
        
        // shadow
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 3, height: 3)
        shadowView.layer.shadowOpacity = 0.7
        shadowView.layer.shadowRadius = 10
        
        //vote Buttons setup
        if (trafficInfo?.isUpvoted!)! {
            upButt.setImage(#imageLiteral(resourceName: "up1_reversed_icon"), for: .normal)
        } else if (trafficInfo?.isDownvoted!)! {
            downButt.setImage(#imageLiteral(resourceName: "down1_reversed_icon"), for: .normal)
        }
    }
    

    func setupDate(point: Int) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"/* date_format_you_want_in_string from
         * http://userguide.icu-project.org/formatparse/datetime
         */
        
        let date = dateFormatter.date(from: (trafficInfo?.updatedAt)!)
        timePointsLb.text = "\(Helpers.timeAgoSinceDate(date: date! as NSDate, numericDates: false)) | \(point) points"
    }
    
    func vote(isUp: Bool, id: String) {
        //self.showLoading()
        let token = UserDefaults.standard.string(forKey: "Token")
        let userID = UserDefaults.standard.string(forKey: "UserID")
        let param = ["userId": userID!]
        if isUp {
            ServiceHelpers.upvoteEvent(param: param, eventID: id, token: token!){(response) in
                self.upVoteResponse = response
                
            }
        } else {
            ServiceHelpers.downvoteEvent(param: param, eventID: id, token: token!){(response) in
                self.downVoteResponse = response
            }
        }
    }
    
    ////Button actions
    @IBAction func imagePressed(_ sender: Any) {
        if imageAvailable {
            imageBottomConstraint.constant = 0
            blackView.isHidden = false
            blackView.alpha = 0.25
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
        } else {
            let alert = UIAlertController(title: "Thông báo", message: "Không tìm thấy hình ảnh giao thông", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func disagreePressed(_ sender: Any) {
        if (trafficInfo?.isDownvoted)! {
            downButt.setImage(#imageLiteral(resourceName: "down1_icon"), for: .normal)
        } else {
            downButt.setImage(#imageLiteral(resourceName: "down1_reversed_icon"), for: .normal)
        }
        upButt.setImage(#imageLiteral(resourceName: "up1_icon"), for: .normal)
        self.vote(isUp: false, id: (trafficInfo?.id)!)
        trafficInfo?.isDownvoted = !(trafficInfo?.isDownvoted)!
        trafficInfo?.isUpvoted = false
    }
    
    @IBAction func agreePressed(_ sender: Any) {
        if (trafficInfo?.isUpvoted)! {
            upButt.setImage(#imageLiteral(resourceName: "up1_icon"), for: .normal)
        } else {
            upButt.setImage(#imageLiteral(resourceName: "up1_reversed_icon"), for: .normal)
        }
        downButt.setImage(#imageLiteral(resourceName: "down1_icon"), for: .normal)
        self.vote(isUp: true, id: (trafficInfo?.id)!)
        trafficInfo?.isUpvoted = !(trafficInfo?.isUpvoted)!
        trafficInfo?.isDownvoted = false
    }
    
    @IBAction func mapPressed(_ sender: Any) {
        let vc = MapTrafficDetailsViewController()
        vc.sourceCoor = CLLocationCoordinate2D(latitude: CLLocationDegrees( (trafficInfo?.startLatitude)!), longitude: CLLocationDegrees( (trafficInfo?.startLongtitude)!))
        vc.destCoor = CLLocationCoordinate2D(latitude: CLLocationDegrees( (trafficInfo?.endLatitude)!), longitude: CLLocationDegrees( (trafficInfo?.endLongtitude)!))
        vc.density = trafficInfo?.density
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func closeImage() {
        imageBottomConstraint.constant = -SCREEN_HEIGHT
        blackView.isHidden = true
        blackView.alpha = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    ////Table View functions
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50

    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trafficTitles.count

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrafficDetailsTableViewCell") as! TrafficDetailsTableViewCell
        cell.populate(title: trafficTitles[indexPath.row], content: trafficContents[indexPath.row])
        
        return cell
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
