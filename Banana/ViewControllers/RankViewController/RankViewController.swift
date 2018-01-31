//
//  RankViewController.swift
//  Banana
//
//  Created by TQM on 9/9/17.
//  Copyright © 2017 Minh Tran. All rights reserved.
//

import UIKit

class RankViewController: BaseViewController,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegateFlowLayout,UIPickerViewDelegate,UIPickerViewDataSource {

    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var pickerUIView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLb: UILabel!
    
    var years: [String] = []
    var months: [String] = []
    var pickerList: [String] = []
    var choosingMonth = ""
    var choosingYear = ""
    var allTimeUsers: [UsersObject] = []
    var monthUsers: [UsersObject] = []
    var yearUsers: [UsersObject] = []
    var allTimeResponse: GetLeaderBoardResponse?
    {
        didSet{
            self.hideLoading()
            if (allTimeResponse?.success)!
            {
                allTimeUsers = (allTimeResponse?.data)!
                tableView.reloadData()
            }
            else{
                let alert = UIAlertController(title: "Error!", message: "Trouble getting leaderboard.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    var monthResponse: GetLeaderBoardResponse?
    {
        didSet{
            if (monthResponse?.success)!
            {
                monthUsers = (monthResponse?.data)!
                tableView.reloadData()
            }
            else{
                let alert = UIAlertController(title: "Error!", message: "Trouble getting leaderboard.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    var yearResponse: GetLeaderBoardResponse?
    {
        didSet{
            if (yearResponse?.success)!
            {
                yearUsers = (yearResponse?.data)!
                tableView.reloadData()
            }
            else{
                let alert = UIAlertController(title: "Error!", message: "Trouble getting leaderboard.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    var filterList = ["All Time","Year","Month"]
    var choosingOption = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getDate()
        selectItem()
    }
    
    func getDate()
    {
        var now = NSDate()
        print(now)
        var time = now.timeIntervalSince1970 * 1000
        var string = "\(time)"
        print(time)
        
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: now as Date)
        let month = calendar.component(.month, from: now as Date)
        choosingMonth = String(month)
        choosingYear = String(year)
        print(year)
        print(month)
        
        years = []
        months = []
        
        if String(year) == DataMgr.shared.years[0]
        {
            years.append(String(year))
        }
        else{
            years = DataMgr.shared.years
        }
        
        for i in 0...month - 1
        {
            months.append(DataMgr.shared.months[i])
        }
        
        let monthDate = dateToDouble(date: dateToString(year: String(year), month: String(month)))
        print(monthDate)
        loadDB(monthTime: monthDate, yearTime: Double(year))
        
    }
    
    func loadDB(monthTime: Double, yearTime: Double)
    {
        self.showLoading()
        ServiceHelpers.getLeaderboardYear(time: String(yearTime)){(response) in
            self.yearResponse = response
        }
        ServiceHelpers.getLeaderboardMonth(time: String(monthTime)){(response) in
            self.monthResponse = response
        }
        ServiceHelpers.getLeaderboardAllTime{(response) in
            self.allTimeResponse = response
        }
    }
    
    func setupView()
    {
        // corner radius
        middleView.layer.cornerRadius = 10
        shadowView.layer.cornerRadius = 10
        
        // shadow
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 3, height: 3)
        shadowView.layer.shadowOpacity = 0.7
        shadowView.layer.shadowRadius = 10
        
        //picker view setup
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerUIView.layer.cornerRadius = 10
        
        //collection view setup
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.layer.backgroundColor = UIColor.clear.cgColor
        collectionView.register(UINib(nibName: "ListCollectionViewCell",bundle: nil), forCellWithReuseIdentifier: "ListCollectionViewCell")
        //table view setup
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "RankViewTableViewCell",bundle: nil), forCellReuseIdentifier: "RankViewTableViewCell")
        
        //add top rounded corners for title view
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.titleView.frame
        rectShape.position = self.titleView.center
        rectShape.path = UIBezierPath(roundedRect: self.titleView.bounds, byRoundingCorners: [.topRight , .topLeft], cornerRadii: CGSize(width: 10, height: 10)).cgPath
        self.titleView.layer.mask = rectShape
        
        //add tap gesture for title view
        titleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showOptions)))
        //add tap gesture for black view
        blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeOptions)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //pickerView functions
    ////PickerView functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return pickerList[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
//        contentList[currentIndexPath] = pickerList[row]
//        submitList[currentIndexPath] = row
//        isTouched[currentIndexPath] = 1
        //tableView.reloadData()
        if choosingOption == 1
        {
            choosingYear = filterList[row]
        }
        else if choosingOption == 2
        {
            choosingMonth = String(row + 1)
        }
    }
    ////collection view functions
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60.0, height: 45.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        //Where elements_count is the count of all your items in that
        //Collection view...
        let cellCount = CGFloat(filterList.count)
        
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCollectionViewCell", for: indexPath) as! ListCollectionViewCell
        
        cell.populate(title: filterList[indexPath.row])
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            choosingOption = 0
            titleLb.text = "All Time"
        case 1:
            choosingOption = 1
            titleLb.text = choosingYear
        case 2:
            choosingOption = 2
            titleLb.text = DataMgr.shared.months[(Int(choosingMonth))! - 1]
        default:
            break
        }
        tableView.reloadData()
    }
    
    ////table view functions
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.choosingOption {
        case 0:
            return allTimeUsers.count
        case 1:
            return yearUsers.count
        case 2:
            return monthUsers.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var list:[UsersObject] = []
        switch self.choosingOption {
        case 0:
            list = allTimeUsers
        case 1:
            list = yearUsers
        case 2:
            list = monthUsers
        default:
            break
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "RankViewTableViewCell") as! RankViewTableViewCell
        cell.populate(usrInfo: list[indexPath.row], position: indexPath.row + 1, choosingOption: choosingOption)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var list:[UsersObject] = []
        switch self.choosingOption {
        case 0:
            list = allTimeUsers
        case 1:
            list = yearUsers
        case 2:
            list = monthUsers
        default:
            break
        }
        let vc = UserInfoViewController()
        vc.userInfo = list[indexPath.row]
        self.present(vc, animated: true, completion: nil)
    }

    
    func showOptions()
    {
        if choosingOption == 1
        {
            pickerList = years
            pickerView.reloadAllComponents()
            blackView.isHidden = false
            pickerUIView.isHidden = false
        }
        else if choosingOption == 2
        {
            pickerList = months
            pickerView.reloadAllComponents()
            let month = Int(choosingMonth)
            pickerView.selectRow(month! - 1, inComponent: 0, animated: false)
            blackView.isHidden = false
            pickerUIView.isHidden = false
        }
    }
    
    func closeOptions()
    {
        blackView.isHidden = true
        pickerUIView.isHidden = true
    }
    
    func selectItem()
    {
        collectionView.selectItem(at: IndexPath.init(row: choosingOption, section: 0), animated: false, scrollPosition: .left)
        titleLb.text = "All Time"
    }
    
    func dateToString(year: String,month: String) -> Date
    {
        let stringDate = "\(year)-\(month)-01 00:00:00 +0000"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
         // http://userguide.icu-project.org/formatparse/datetime
        
        let date = dateFormatter.date(from: stringDate)
        
        return date!
    }
    
    func dateToDouble(date: Date) -> Double
    {
        let dateInDouble = date.timeIntervalSince1970 * 1000
        return dateInDouble
    }
    
    @IBAction func choosePressed(_ sender: Any) {
        closeOptions()
        if choosingOption == 1
        {
            titleLb.text = choosingYear
            ServiceHelpers.getLeaderboardYear(time: choosingYear){(response) in
                self.yearResponse = response
                
            }
            
        }
        else if choosingOption == 2
        {
            titleLb.text = DataMgr.shared.months[(Int(choosingMonth))! - 1]
            let date = dateToDouble(date: dateToString(year: choosingYear, month: choosingMonth))
            ServiceHelpers.getLeaderboardMonth(time: String(date)){(response) in
                self.monthResponse = response
                
            }
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

}
