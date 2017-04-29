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
    
    func drawLoopLayer(aqi: CGFloat, color: CGColor) {
        let circle = UIBezierPath(arcCenter: CGPoint(x: SCREN_WIDTH / 2, y: self.frame.midY + 20), radius: 100, startAngle: startP, endAngle: degreeToRadius(ang: 30), clockwise: true)
        let bgLayer = CAShapeLayer()
        bgLayer.frame = self.bounds
        bgLayer.fillColor = UIColor.clear.cgColor
        bgLayer.lineWidth = 15
        bgLayer.lineCap = kCALineCapRound
        bgLayer.strokeColor = UIColor.gray.cgColor
        bgLayer.path = circle.cgPath
        self.layer.addSublayer(bgLayer)
        
        let valuePath = UIBezierPath(arcCenter: CGPoint(x: SCREN_WIDTH / 2, y: self.frame.midY + 20), radius: 100, startAngle: startP, endAngle: (-210 + aqi / 500.0 * 240.0) * CGFloat(Double.pi) / 180, clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = self.bounds
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 15
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.strokeColor = color
        shapeLayer.path = valuePath.cgPath
        self.layer.addSublayer(shapeLayer)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
