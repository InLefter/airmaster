//
//  LoopAQICell.swift
//  airmaster
//
//  Created by Howie on 2017/4/27.
//  Copyright © 2017年 Howie. All rights reserved.
//

import UIKit

class LoopAQICell: UITableViewCell {

    @IBOutlet weak var loopView: UIView!
    @IBOutlet weak var AQI: UILabel!
    @IBOutlet weak var standard: UILabel!
    @IBOutlet weak var quality: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func drawLoop() {
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
