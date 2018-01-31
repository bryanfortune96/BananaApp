//
//  SubmitDetailsViewController.swift
//  Banana
//
//  Created by TQM on 9/23/17.
//  Copyright © 2017 Minh Tran. All rights reserved.
//

import UIKit
import MarqueeLabel
import GoogleMaps

class SubmitDetailsViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet weak var distanceLb: UILabel!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var titleLb: MarqueeLabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var pickerUIView: UIView!
    @IBOutlet weak var chooseButt: UIButton!
    
    var trafficImage: UIImage?
    var district: Int?
    var start_coor: CLLocationCoordinate2D?
    var end_coor: CLLocationCoordinate2D?
    var distance = ""
    var placeName = ""
    var titleElements = ["Lưu lượng xe","Xe máy","Xe hơi","Mưa","Tai nạn","Ngập lụt","CSGT","Khuyến cáo"]
    var contentList = ["Đông xe","Di chuyển chậm","Di chuyển chậm","Không","Không","Không","Không","Không nên di chuyển"]
    var submitList = [3,1,1,0,0,0,0,0]
    var isTouched = [0,0,0,0,0,0,0,0]
    var submitData: Dictionary<String,Any> = [:]
    var submitInfo = TrafficInfo()
    var response: PostEventResponse?
    {
        didSet{
            self.hideLoading()
            if (response?.success)!
            {
                self.submitResponse = response?.data
            }
            else{
                let alert = UIAlertController(title: "Warning!", message: response?.message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    var submitResponse: EventDetailsObject?
    {
        didSet{
            NotificationCenter.default.post(name: NSNotification.Name("CloseSubmitView"), object: nil)
            self.dismiss(animated: true, completion: nil)
        }
    }
    var currentIndexPath = 0
    var pickerList:[String] = []
    var submitSuceeded = false
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        // Do any additional setup after loading the view.
    }

    func initialize()
    {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SubmitDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "SubmitDetailsTableViewCell")
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.isHidden = true
        pickerUIView.isHidden = true
        blackView.isHidden = true
        
        // corner radius
        middleView.layer.cornerRadius = 10
        shadowView.layer.cornerRadius = 10
        pickerUIView.layer.cornerRadius = 10
        
        
        // shadow
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 3, height: 3)
        shadowView.layer.shadowOpacity = 0.7
        shadowView.layer.shadowRadius = 10
        pickerUIView.layer.shadowColor = UIColor.black.cgColor
        pickerUIView.layer.shadowOffset = CGSize(width: 3, height: 3)
        pickerUIView.layer.shadowOpacity = 0.7
        pickerUIView.layer.shadowRadius = 10
        
        blackView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(closeOptions)))
        
        titleLb.text = "\(placeName)                    "
        distanceLb.text = distance
    }
    
    func getDistrict()
    {
        let districts = DataMgr.shared.districts
        for x in districts
        {
            var title = "\(x.title),"
            if placeName.range(of: title) != nil
            {
                district = x.id
                return
            }
        }
        let alert = UIAlertController(title: "Chú ý!", message: "Không thể tìm thấy quận. Vui lòng chọn lại!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func cameraPressed(_ sender: Any) {
        let alert = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
        
        // Change Message With Color and Font
        let alertMsg  = "Hình ảnh mô tả"
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: alertMsg as String, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18)])
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor(white: 34.0 / 255.0, alpha: 1.0), range: NSRange(location: 0, length: alertMsg.characters.count))
        alert.setValue(myMutableString, forKey: "attributedTitle")
        
        alert.addAction(UIAlertAction(title: "Chụp hình", style: .default, handler: {
            action in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Thư viện", style: .default, handler: {
            action in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Hủy", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func confirmPressed(_ sender: Any) {
        self.showLoading()
        getDistrict()
        let token = UserDefaults.standard.string(forKey: "Token")
        let userID = UserDefaults.standard.string(forKey: "UserID")
        submitData = ["userId": userID! as Any,"name": placeName,"eventType":0,"latitude": Float((start_coor?.latitude)!),"longitude": Float((start_coor?.longitude)!) as Any,"end_latitude": Float((end_coor?.latitude)!) as Any,"end_longitude": Float((end_coor?.longitude)!) as Any,"density": submitList[0],"motorbike_speed": submitList[1],"car_speed": submitList[2],"has_rain": DataMgr.shared.booleanStyle[submitList[3]], "has_accident": DataMgr.shared.booleanStyle[submitList[4]], "has_flood": DataMgr.shared.booleanStyle[submitList[5]],"should_travel":DataMgr.shared.booleanStyle[submitList[6]],"district": district! as Any]
        ServiceHelpers.postEvent(param: submitData, token: (token)!) { (response) in
            self.response = response
            
        }
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func choosePressed(_ sender: Any) {
        self.closeOptions()
    }

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
        
        contentList[currentIndexPath] = pickerList[row]
        submitList[currentIndexPath] = row
        isTouched[currentIndexPath] = 1
        tableView.reloadData()
        
    }
    
    @objc func closeOptions()
    {
        UIView.animate(withDuration: 1, animations: {
            self.blackView.isHidden = true
            self.pickerUIView.isHidden = true
            self.pickerView.isHidden = true
        })
    }
    
    
    ////TablewView functions
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleElements.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubmitDetailsTableViewCell") as! SubmitDetailsTableViewCell
    
        cell.populate(title: titleElements[indexPath.row], content: contentList[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            pickerList = DataMgr.shared.density
            currentIndexPath =  indexPath.row
            pickerView.reloadAllComponents()
            if isTouched[indexPath.row] == 0
            {
                pickerView.selectRow(3, inComponent: 0, animated: false)
            }
            else{
                pickerView.selectRow(submitList[indexPath.row], inComponent: 0, animated: false)
            }
        case 1,2:
            pickerList = DataMgr.shared.movability
            currentIndexPath =  indexPath.row
            pickerView.reloadAllComponents()
            if isTouched[indexPath.row] == 0
            {
                pickerView.selectRow(1, inComponent: 0, animated: false)
            }
            else{
                pickerView.selectRow(submitList[indexPath.row], inComponent: 0, animated: false)
            }
        case 3,4,5,6:
            pickerList = DataMgr.shared.bool
            currentIndexPath =  indexPath.row
            pickerView.reloadAllComponents()
            if isTouched[indexPath.row] == 0
            {
                pickerView.selectRow(0, inComponent: 0, animated: false)
            }
            else{
                pickerView.selectRow(submitList[indexPath.row], inComponent: 0, animated: false)
            }
        case 7:
            pickerList = DataMgr.shared.recommendation
            currentIndexPath =  indexPath.row
            pickerView.reloadAllComponents()
            if isTouched[indexPath.row] == 0
            {
                pickerView.selectRow(1, inComponent: 0, animated: false)
            }
            else{
                pickerView.selectRow(submitList[indexPath.row], inComponent: 0, animated: false)
            }
        default:
            break
        }
    
        //currentIndexPath =  indexPath.row
        //pickerView.reloadAllComponents()
        UIView.animate(withDuration: 1, animations: {
            self.blackView.isHidden = false
            self.pickerUIView.isHidden = false
            self.pickerView.isHidden = false
        })
    }
}

extension SubmitDetailsViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            trafficImage = pickedImage
        }
        dismiss(animated: true, completion: nil)

    }
}

extension SubmitDetailsViewController: UINavigationControllerDelegate {
    
}


