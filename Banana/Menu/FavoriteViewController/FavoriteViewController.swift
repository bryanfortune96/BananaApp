//
//  FavoriteViewController.swift
//  Banana
//
//  Created by TQM on 10/5/17.
//  Copyright © 2017 Minh Tran. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var middleView: UIView!
    
    var districtList: [District] = []
    var popAreaList = [""]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup()
    {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "FavoriteTableViewCell", bundle: nil), forCellReuseIdentifier: "FavoriteTableViewCell")
        
        // corner radius
        middleView.layer.cornerRadius = 10
        shadowView.layer.cornerRadius = 10
        
        
        // shadow
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 3, height: 3)
        shadowView.layer.shadowOpacity = 0.7
        shadowView.layer.shadowRadius = 10
        
        
        let def = Int32(UserDefaults.standard.integer(forKey: "BitMask"))
        DataMgr.shared.updateDistrict(districtsBitMask: def)
        districtList = DataMgr.shared.getDistricts()
    }
    
    //table view functions
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return districtList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTableViewCell") as! FavoriteTableViewCell
        cell.delegate = self
        cell.populate(district: districtList[indexPath.row],position: indexPath.row)
        
        return cell
    }
    
    @IBAction func backPressed(_ sender: Any) {
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

extension FavoriteViewController: FavoriteTapDelegate{
    func notify(isChecked: Bool, position: Int, isEmpty: Bool) {
        if isEmpty
        {
            let alert = UIAlertController(title: "Chú ý!", message: "Vui lòng chọn ít nhất một quận", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            DataMgr.shared.getDistrict(index: position).isFavorite = isChecked
            DataMgr.shared.saveDistrictsBitMask()
            UserDefaults.standard.set(DataMgr.shared.getDistrictsBitMask(), forKey: "BitMask")
        }
    }
}


