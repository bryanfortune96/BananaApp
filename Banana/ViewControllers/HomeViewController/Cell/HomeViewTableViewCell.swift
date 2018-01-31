//
//  HomeViewTableViewCell.swift
//  Banana
//
//  Created by TQM on 9/30/17.
//  Copyright © 2017 Minh Tran. All rights reserved.
//

import UIKit

class HomeViewTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLb: UILabel!
    var index: Int?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func populate(title: String,image: UIImage,index: Int)
    {
        titleLb.text = title
//        let image = image.withRenderingMode(.alwaysTemplate)
        imgView.image = image
//        imgView.tintColor = UIColor.gray
        self.index = index
        
    }
    
}
