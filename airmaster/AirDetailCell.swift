//
//  AirDetailCell.swift
//  airmaster
//
//  Created by Howie on 2017/4/25.
//  Copyright © 2017年 Howie. All rights reserved.
//

import UIKit

class AirDetailCell: UITableViewCell {

    @IBOutlet weak var positionIcon: UIImageView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var AQI: UILabel!
    @IBOutlet weak var airQuality: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
