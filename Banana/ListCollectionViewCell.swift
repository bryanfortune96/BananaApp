//
//  ListCollectionViewCell.swift
//  Banana
//
//  Created by TQM on 9/17/17.
//  Copyright © 2017 Minh Tran. All rights reserved.
//

import UIKit
import MarqueeLabel

class ListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        label.textColor = UIColor.gray
        // Initialization code
    }
    
    override var isSelected: Bool
    {
        set(value)
        {
            super.isSelected = value
            setSelection()
        }
        get{
            return super.isSelected
        }
    }
    
    func populate(title: String)
    {
        label.text = title
    }
    
    func setSelection()
    {
        if self.isSelected{
            label.textColor = UIColor.white
        }
        else{
            label.textColor = UIColor.gray
        }
    }

}
