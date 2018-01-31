//
//  FavoriteTableViewCell.swift
//  Banana
//
//  Created by TQM on 10/5/17.
//  Copyright © 2017 Minh Tran. All rights reserved.
//

import UIKit
protocol FavoriteTapDelegate {
    func notify(isChecked: Bool,position: Int,isEmpty: Bool)
    
}

class FavoriteTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLb: UILabel!
    
    @IBOutlet weak var popAreaLb: UILabel!
    
    @IBOutlet weak var favoriteButt: UIButton!
    var dist: District?
    var pos = 0
    var delegate: FavoriteTapDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func favoritePressed(_ sender: Any) {
        let districtList = DataMgr.shared.getDistricts()
        let filteredList = districtList.filter({x in
            x.isFavorite == true
        })
        
        if filteredList.count == 1 && (dist?.isFavorite)!
        {
            self.delegate?.notify(isChecked: !(dist?.isFavorite)!, position: pos, isEmpty: true)
            if !(dist?.isFavorite)!
            {
                favoriteButt.setImage(#imageLiteral(resourceName: "favorite_checked_icon"), for: .normal)
            }
        }
        else{
            self.delegate?.notify(isChecked: !(dist?.isFavorite)!, position: pos, isEmpty: false)
            if (dist?.isFavorite)!
            {
                favoriteButt.setImage(#imageLiteral(resourceName: "favorite_checked_icon"), for: .normal)

            }
            else{
                favoriteButt.setImage(#imageLiteral(resourceName: "favorite_unchecked_icon"), for: .normal)

            }
        }
        
        
        
        
    }
    
    func populate(district: District,position: Int)
    {
        pos = position
        dist = district
        titleLb.text = district.title
        popAreaLb.text = district.popArea
        if district.isFavorite
        {
            favoriteButt.setImage(#imageLiteral(resourceName: "favorite_checked_icon"), for: .normal)
        }
        else{
            favoriteButt.setImage(#imageLiteral(resourceName: "favorite_unchecked_icon"), for: .normal)

    }
    }
        
    
    
}
