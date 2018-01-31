//
//  TrafficDetailsTableViewCell.swift
//  Banana
//
//  Created by TQM on 9/22/17.
//  Copyright © 2017 Minh Tran. All rights reserved.
//

import UIKit

class TrafficDetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var contentLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populate(title: String,content: String)
    {
        titleLb.text = title
        contentLb.text = content
    }
    
}
