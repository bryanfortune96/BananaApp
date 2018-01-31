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

class TrafficDetailsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var titleLb: MarqueeLabel!
    @IBOutlet weak var timePointsLb: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var trafficTitles = ["Số người đăng","Lưu lượng xe","Xe máy","Xe hơi","Mưa","Tai nạn","Ngập lụt","CSGT","Khuyến cáo"]
    var trafficInfo: EventDetailsObject?
    var trafficContents:[String] = []
    
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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TrafficDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "TrafficDetailsTableViewCell")
      
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"/* date_format_you_want_in_string from
         * http://userguide.icu-project.org/formatparse/datetime
         */
        
        let date = dateFormatter.date(from: (trafficInfo?.updatedAt)!)
        
        titleLb.text = "\((trafficInfo?.name)!)                     "
        timePointsLb.text = "\(Helpers.timeAgoSinceDate(date: date! as NSDate, numericDates: false)) | 0 points"
        trafficContents = ["15", DataMgr.shared.density[(trafficInfo?.density)!], DataMgr.shared.movability[(trafficInfo?.bikeSpeed)!], DataMgr.shared.movability[(trafficInfo?.carSpeed)!], (trafficInfo?.isRaining)! ? "Có" : "Không", (trafficInfo?.isAccident)! ? "Có" : "Không", (trafficInfo?.isFlood)! ? "Có" : "Không", "Không", (trafficInfo?.isRecommended)! ? "Nên di chuyển" : "Không nên di chuyển"]
        
        // corner radius
        middleView.layer.cornerRadius = 10
        shadowView.layer.cornerRadius = 10
        
        
        // shadow
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 3, height: 3)
        shadowView.layer.shadowOpacity = 0.7
        shadowView.layer.shadowRadius = 10
    }
    
    ////Button actions
    @IBAction func facebookPressed(_ sender: Any) {
        
    }
    
    @IBAction func disagreePressed(_ sender: Any) {
//        trafficInfo?.point -= 1
//        timePointsLb.text = "\(Helpers.timeAgoSinceDate(date: (trafficInfo?.time)!, numericDates: false)) | \(String(describing: trafficInfo?.point) ) points"

    }
    
    @IBAction func agreePressed(_ sender: Any) {
//        trafficInfo?.point += 1
//        timePointsLb.text = "\(Helpers.timeAgoSinceDate(date: (trafficInfo?.time)!, numericDates: false)) | \(String(describing: trafficInfo?.point) ) points"

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
