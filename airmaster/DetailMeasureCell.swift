//
//  DetailMeasureCell.swift
//  airmaster
//
//  Created by Howie on 2017/5/24.
//  Copyright © 2017年 Howie. All rights reserved.
//

import UIKit

protocol DetailMeasureCellProtocol {
    var icon: String {get}
    var measureItem: String {get}
    var measureText: String {get}
    var level: MeasureLevel {get}
}



struct MeasureInfoCellModel: DetailMeasureCellProtocol {
    var icon: String
    var measureItem: String
    var measureText: String
    var level: MeasureLevel
    
    init(info: MeasureInfo, row: Int) {
        self.level = info.level
        self.measureText = info.text
        switch row {
        case 0:
            icon = "old-child"
            measureItem = MeasureItem.OldChild.rawValue
            break
        case 1:
            icon = "open-window"
            measureItem = MeasureItem.OpenWindows.rawValue
            break
        case 2:
            icon = "wear-mask"
            measureItem = MeasureItem.WearMask.rawValue
            break
        default:
            icon = "outdoor-sport"
            measureItem = MeasureItem.OutdoorSport.rawValue
            break
        }
    }

}

class DetailMeasureCell: UITableViewCell {

    @IBOutlet weak var measureView: MeasureView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(withDelegate delegate: MeasureInfoCellModel) {
        measureView.icon.image = UIImage(named: delegate.icon)
        measureView.measureItem.text = delegate.measureItem
        measureView.measureText.text = delegate.measureText
        measureView.iconBackView.backgroundColor = UIColor(dex: delegate.level.rawValue)
        measureView.iconBackView.layer.cornerRadius = measureView.iconBackView.frame.size.width / 2
    }
    
}
