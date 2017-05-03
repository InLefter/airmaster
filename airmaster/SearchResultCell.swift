//
//  SearchResultCell.swift
//  airmaster
//
//  Created by Howie on 2017/5/3.
//  Copyright © 2017年 Howie. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var area: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
