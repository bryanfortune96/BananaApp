//
//  SubmitDetailsTableViewCell.swift
//  Banana
//
//  Created by TQM on 9/22/17.
//  Copyright © 2017 Minh Tran. All rights reserved.
//

import UIKit

class SubmitDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var contentUIView: UIView!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var contentLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        contentUIView.layer.cornerRadius = 10
        
        contentUIView.layer.borderColor = UIColor.lightGray.cgColor
        contentUIView.layer.borderWidth = 1.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populate(title: String, content: String)
    {
        titleLb.text = title
        contentLb.text = content
    }
}
