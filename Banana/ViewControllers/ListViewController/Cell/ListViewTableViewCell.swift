//
//  ListViewTableViewCell.swift
//  Banana
//
//  Created by TQM on 9/14/17.
//  Copyright © 2017 Minh Tran. All rights reserved.
//

import UIKit
import MarqueeLabel

protocol VotingDelegate {
    func vote(isUp: Bool,id: String)
}

class ListViewTableViewCell: UITableViewCell {

    
    @IBOutlet weak var upButt: UIButton!
    @IBOutlet weak var downButt: UIButton!
    @IBOutlet weak var titleLb: MarqueeLabel!
    @IBOutlet weak var infoLb: UILabel!
    @IBOutlet weak var jamIcon: UIImageView!
    @IBOutlet weak var accidentIcon: UIImageView!
    @IBOutlet weak var rainIcon: UIImageView!
    @IBOutlet weak var floodIcon: UIImageView!
    var id: String?
    var trafficInfo: EventDetailsObject?
    
    var delegate: VotingDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        jamIcon.isHidden = true
        accidentIcon.isHidden = true
        rainIcon.isHidden = true
        floodIcon.isHidden = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func upPressed(_ sender: Any) {
        if (trafficInfo?.isUpvoted)! {
            upButt.setImage(#imageLiteral(resourceName: "up1_icon"), for: .normal)
        } else {
            upButt.setImage(#imageLiteral(resourceName: "up1_reversed_icon"), for: .normal)
        }
        downButt.setImage(#imageLiteral(resourceName: "down1_icon"), for: .normal)
        self.delegate?.vote(isUp: true, id: (trafficInfo?.id)!)
        
    }
    
    @IBAction func downPressed(_ sender: Any) {
        if (trafficInfo?.isDownvoted)! {
            downButt.setImage(#imageLiteral(resourceName: "down1_icon"), for: .normal)
        } else {
            downButt.setImage(#imageLiteral(resourceName: "down1_reversed_icon"), for: .normal)
        }
        upButt.setImage(#imageLiteral(resourceName: "up1_icon"), for: .normal)
        self.delegate?.vote(isUp: false, id: (trafficInfo?.id)!)
        
    }
    
    func populate(trafficInfo: EventDetailsObject)
    {
        downButt.setImage(#imageLiteral(resourceName: "down1_icon"), for: .normal)
        upButt.setImage(#imageLiteral(resourceName: "up1_icon"), for: .normal)
        
        self.trafficInfo = trafficInfo
        id = trafficInfo.id
        titleLb.text = "\((trafficInfo.name)!)                   "
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"/* date_format_you_want_in_string from
         * http://userguide.icu-project.org/formatparse/datetime
         */
        
        let date = dateFormatter.date(from: (trafficInfo.updatedAt)!)
        
        let time = Helpers.timeAgoSinceDate(date: date as! NSDate, numericDates: false)
        let point = (trafficInfo.point?.upVotes)! - (trafficInfo.point?.downVotes)!
        infoLb.text = "\(time) | \(point) points"
        
        if trafficInfo.isUpvoted! {
            upButt.setImage(#imageLiteral(resourceName: "up1_reversed_icon"), for: .normal)
            downButt.setImage(#imageLiteral(resourceName: "down1_icon"), for: .normal)
        } else if trafficInfo.isDownvoted! {
            downButt.setImage(#imageLiteral(resourceName: "down1_reversed_icon"), for: .normal)
            upButt.setImage(#imageLiteral(resourceName: "up1_icon"), for: .normal)
        }
        
        if trafficInfo.isAccident!
        {
            accidentIcon.isHidden = false
        }
        if trafficInfo.isFlood!
        {
            floodIcon.isHidden = false
        }
        if trafficInfo.isRaining!
        {
            rainIcon.isHidden = false
        }
        if trafficInfo.density != 0
        {
            jamIcon.isHidden = false

        }
        if trafficInfo.density == 1
        {
            jamIcon.image = #imageLiteral(resourceName: "moderateJam_icon")
        }
        else if trafficInfo.density == 2
        {
            jamIcon.image = #imageLiteral(resourceName: "heavyJam_icon")
        }
        else if trafficInfo.density == 3
        {
            jamIcon.image = #imageLiteral(resourceName: "superHeavyJam_icon")
        }
    }
}
