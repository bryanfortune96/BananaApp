//
//  BaseViewTableViewCell.swift
//  Banana
//
//  Created by TQM on 9/26/17.
//  Copyright © 2017 Minh Tran. All rights reserved.
//

import UIKit

class BaseViewTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populate(title: String,image: UIImage)
    {
        titleLb.text = title
        imageView?.image = image
    }
    
}
