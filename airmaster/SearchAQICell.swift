//
//  SearchAQICell.swift
//  airmaster
//
//  Created by Howie on 2017/5/2.
//  Copyright © 2017年 Howie. All rights reserved.
//

import UIKit

class SearchAQICell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var aqi: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.aqi.layer.cornerRadius = 5
        self.aqi.tintColor = UIColor.white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
