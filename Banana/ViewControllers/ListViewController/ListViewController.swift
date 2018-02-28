//
//  ListViewController.swift
//  Banana
//
//  Created by TQM on 9/9/17.
//  Copyright © 2017 Minh Tran. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire


class ListViewController: BaseViewController,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var refreshTime: UILabel!
    
    @IBOutlet weak var shadowView: UIView!
 
    var upVoteResponse: UpvoteEventResponse? {
        didSet {
            if (upVoteResponse?.success)! {
                refresh()
            } else {
                self.hideLoading()
                let alert = UIAlertController(title: "Warning!", message: upVoteResponse?.message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    var downVoteResponse: DownvoteEventResponse? {
        didSet {
            if (downVoteResponse?.success)! {
                refresh()
            } else {
                self.hideLoading()
                let alert = UIAlertController(title: "Warning!", message: downVoteResponse?.message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    var districtsList:[District] = []
    var filterTrafficList:[EventDetailsObject] = []
    var selectedDistrict: District?
    var isRefreshing = false
    var response: EventListResponse? {
        didSet {
            self.hideLoading()
            if (response?.success)! {
                self.trafficList = (response?.data)!
            } else {
                let alert = UIAlertController(title: "Warning!", message: response?.message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    var trafficList:[EventDetailsObject] = [] {
        didSet {
            filterTrafficList = trafficList
            if isRefreshing {
                self.setupScrollView()
                self.collectionView.reloadData()
                self.selectItem()
                tableView.reloadData()
                isRefreshing = false
            } else {
                self.tableView.reloadData()
            }
            
        }
    }
    var timer: Timer?
    var count = 0
    var minute = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //checkForGPS()
        Initialize()
        //loadDB()
       
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refresh()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadDB() {
        self.showLoading()
        let userID = UserDefaults.standard.string(forKey: "UserID")
        
        if userID != "" {
            ServiceHelpers.getEventList(userID: userID!){ (response) in
                self.response = response
            }
        } else {
            ServiceHelpers.getEventList(userID: "-1"){ (response) in
                self.response = response
            }
        }
    }
    
    func checkForGPS() {
        if !CLLocationManager.locationServicesEnabled() {
            let alertVC = UIAlertController(title: "Location is not enabled", message: "For using our app you need to enable Location in Settings", preferredStyle: .actionSheet)
            alertVC.addAction(UIAlertAction(title: "Open Settings", style: .default) { value in
                let path = UIApplicationOpenSettingsURLString
                if let settingsURL = URL(string: path), UIApplication.shared.canOpenURL(settingsURL) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                    } else {
                        // Fallback on earlier versions
                    }
                    
                }
            })
            alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    func Initialize() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ListCollectionViewCell",bundle: nil), forCellWithReuseIdentifier: "ListCollectionViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ListViewTableViewCell", bundle:nil), forCellReuseIdentifier: "ListViewTableViewCell")
        collectionView.layer.backgroundColor = UIColor.clear.cgColor

        // corner radius
        middleView.layer.cornerRadius = 10
        shadowView.layer.cornerRadius = 10
        
        
        // shadow
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 3, height: 3)
        shadowView.layer.shadowOpacity = 0.7
        shadowView.layer.shadowRadius = 10
        
    }
    
    func selectItem() {
        if selectedDistrict == nil
        {
            collectionView.selectItem(at: IndexPath(row: 0,section: 0), animated: false, scrollPosition: .left)
        } else {
            for i in 0...districtsList.count - 1 {
                if districtsList[i].id == selectedDistrict?.id {
                    collectionView.selectItem(at: IndexPath(row: i,section: 0), animated: false, scrollPosition: .left)
                    refreshFilterList(index: i)
                }
            }
        }
    }
    
    
    ////Button actions
    @IBAction func filterPressed(_ sender: Any) {
        let vc = FavoriteViewController()
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func refreshPressed(_ sender: Any) {
        count = 0
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.countFromLastRefresh), userInfo: nil, repeats: true);
        //self.loadDB()
        self.refresh()
    }
    
    ////CollectionView functions
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return districtsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCollectionViewCell", for: indexPath) as! ListCollectionViewCell
        
        cell.populate(title: districtsList[indexPath.row].title)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        refreshFilterList(index: indexPath.row)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 77.0, height: 70.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    
        //Where elements_count is the count of all your items in that
        //Collection view...
        let cellCount = CGFloat(districtsList.count)
    
        //If the cell count is zero, there is no point in calculating anything.
        if cellCount > 0 {
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let cellWidth = flowLayout.itemSize.width + flowLayout.minimumInteritemSpacing
    
            //20.00 was just extra spacing I wanted to add to my cell.
            let totalCellWidth = cellWidth*cellCount + 20.00 * (cellCount-1)
            let contentWidth = collectionView.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right
    
            if (totalCellWidth < contentWidth) {
                //If the number of cells that exists take up less room than the
                //collection view width... then there is an actual point to centering them.
    
                //Calculate the right amount of padding to center the cells.
                let padding = (contentWidth - totalCellWidth) / 2.0
                return UIEdgeInsetsMake(0, padding, 0, padding)
            } else {
                //Pretty much if the number of cells that exist take up
                //more room than the actual collectionView width, there is no
                // point in trying to center them. So we leave the default behavior.
                return UIEdgeInsetsMake(0, 40, 0, 40)
            }
        }
    
        return UIEdgeInsets.zero
    
    }

    ////TableView functions
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return filterTrafficList.count

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListViewTableViewCell") as! ListViewTableViewCell
        cell.delegate = self
        cell.populate(trafficInfo: filterTrafficList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = TrafficDetailsViewController()
        vc.trafficInfo = filterTrafficList[indexPath.row]
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func countFromLastRefresh()
    {
        count += 1
        if (count > 60 ) {
            count = 0
            minute += 1
            if minute == 1 {
                refreshTime.text = "Refreshed \(minute) minute ago"
            } else {
                refreshTime.text = "Refreshed \(minute) minutes ago"
            }
        }
    }
    
    func refresh() {
        isRefreshing = true
        loadDB()
    }
    
    func setupScrollView() {
        districtsList = []
        let def = Int32(UserDefaults.standard.integer(forKey: "BitMask"))
        DataMgr.shared.updateDistrict(districtsBitMask: def)
        let temp = DataMgr.shared.getDistricts()
        for x in temp {
            if x.isFavorite {
                districtsList.append(x)
            }
        }
    }
    
    func refreshFilterList(index: Int) {
        filterTrafficList = []
        selectedDistrict = districtsList[index]
        if selectedDistrict == nil || (selectedDistrict?.title)! == "All" {
            filterTrafficList = trafficList
        }
        else {
            filterTrafficList = []
            for x in trafficList {
                if selectedDistrict?.id == x.district {
                    filterTrafficList.append(x)
                }
            }
        }
        tableView.reloadData()
    }

    func filter() {
        for i in 0...trafficList.count - 1 {
            let calendar = NSCalendar.current
            let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
            let now = NSDate()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"/* date_format_you_want_in_string from
             * http://userguide.icu-project.org/formatparse/datetime
             */
            
            let date = dateFormatter.date(from: (trafficList[i].updatedAt)!)
            
            let now_Date = now as Date
            let earliest = now.earlierDate(date!)
            let latest = (earliest == now_Date) ? date : now_Date
            let components = calendar.dateComponents(unitFlags, from: earliest as Date,  to: (latest)!)
            
            if components.hour! >= 3 {
                trafficList.remove(at: i)
            }
        }
    }
}

extension ListViewController: VotingDelegate {
    
    func vote(isUp: Bool, id: String) {
        self.showLoading()
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
}


