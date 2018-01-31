//
//  RankViewTableViewCell.swift
//  Banana
//
//  Created by TQM on 10/1/17.
//  Copyright © 2017 Minh Tran. All rights reserved.
//

import UIKit

class RankViewTableViewCell: UITableViewCell {

    @IBOutlet weak var positionLb: UILabel!
    @IBOutlet weak var avatarImgView: UIImageView!
    @IBOutlet weak var usrNameLb: UILabel!
    @IBOutlet weak var pointsRankLb: UILabel!
    @IBOutlet weak var rankImgView: UIImageView!
    @IBOutlet weak var rankImgViewWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        avatarImgView.clipsToBounds = true
        avatarImgView.layer.cornerRadius = 60.0/2
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populate(usrInfo: UsersObject,position: Int,choosingOption: Int)
    {
        positionLb.text = String(position)
        avatarImgView.image = #imageLiteral(resourceName: "user")
        let point = choosingOption == 0 ? usrInfo.point : usrInfo.queryPoint
        pointsRankLb.text = "\((point)!) points | \(DataMgr.shared.levels[usrInfo.level!])"
        if usrInfo.nickname == ""
        {
            usrNameLb.text = usrInfo.email
        }
        else{
            usrNameLb.text = usrInfo.nickname

        }
        switch (usrInfo.level)! {
        case 0:
            rankImgView.image = UIImage(named: "1star_icon")
            rankImgViewWidth.constant = 30
        case 1:
            rankImgView.image = UIImage(named: "2star_icon")
            rankImgViewWidth.constant = 60
        case 2:
            rankImgView.image = UIImage(named: "3star_icon")
            rankImgViewWidth.constant = 90
        case 3:
            rankImgView.image = UIImage(named: "4star_icon")
            rankImgViewWidth.constant = 120
        case 4:
            rankImgView.image = UIImage(named: "5star_icon")
            
        default:
            break
        }
        
    }
    
}
