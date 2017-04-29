//
//  DetailDataCell.swift
//  airmaster
//
//  Created by Howie on 2017/4/28.
//  Copyright © 2017年 Howie. All rights reserved.
//

import UIKit

class DetailDataCell: UITableViewCell {
    @IBOutlet var detailDataViews: [DetailDataView]!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    /// 更新DetailDataCell的各污染物状态
    ///
    /// - Parameter pollutions: 各污染物-数组(按照污染程度逆序排列)
    func setDetailDataView(pollutions: Array<PollutionData>) {
        for i in 0..<detailDataViews.count {
            detailDataViews[i].name.text = pollutions[i].name.rawValue
            detailDataViews[i].quality.text = pollutions[i].quality.rawValue
            detailDataViews[i].value.text = String(pollutions[i].value)
            detailDataViews[i].drawColorRect(color: PollutionColor[pollutions[i].quality]!)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
