//
//  Extension.swift
//  airmaster
//
//  Created by Howie on 2017/4/26.
//  Copyright © 2017年 Howie. All rights reserved.
//
import UIKit
import Foundation

extension DateFormatter{
    open static func formatDate(date: String?) -> Date {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: date!)!
    }
}

extension Float{
    public static func toInt(number: Float?) -> Int {
        return Int(number!)
    }
}


extension UIColor{
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    convenience init(dex: Int) {
        self.init(
            red: (dex >> 16) & 0xFF,
            green: (dex >> 8) & 0xFF,
            blue: dex & 0xFF
        )
    }
}

extension UIView{
    
    /// 绘制aqi弧线
    ///
    /// - Parameter aqi: aqi数值
    func drawLoopLayer(aqi: CGFloat) {
        var lineColor: CGColor
        switch aqi {
        case 0...50:
            lineColor = UIColor(dex: 0x00ff00).cgColor
            break
        case 51...100:
            lineColor = UIColor(dex: 0xd2dd29).cgColor
            break
        case 101...150:
            lineColor = UIColor(dex: 0xdd7e6b).cgColor
            break
        case 151...200:
            lineColor = UIColor(dex: 0xcc0000).cgColor
            break
        case 201...300:
            lineColor = UIColor(dex: 0xd700d0).cgColor
            break
        default:
            lineColor = UIColor(dex: 0x961900).cgColor
            break
        }
        
        let circle = UIBezierPath(arcCenter: CGPoint(x: self.frame.width / 2, y: self.frame.height / 2), radius: min(self.frame.width, self.frame.height) - 8, startAngle: startP, endAngle: degreeToRadius(ang: 30), clockwise: true)
        let bgLayer = CAShapeLayer()
        bgLayer.frame = self.bounds
        bgLayer.fillColor = UIColor.clear.cgColor
        bgLayer.lineWidth = 10
        bgLayer.lineCap = kCALineCapRound
        bgLayer.strokeColor = UIColor.gray.cgColor
        bgLayer.path = circle.cgPath
        self.layer.addSublayer(bgLayer)
        
        let valuePath = UIBezierPath(arcCenter: CGPoint(x: self.frame.width / 2, y: self.frame.height / 2), radius: min(self.frame.width, self.frame.height) - 8, startAngle: startP, endAngle: (-210 + aqi / 500.0 * 240.0) * CGFloat(Double.pi) / 180, clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = self.bounds
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.strokeColor = lineColor
        shapeLayer.path = valuePath.cgPath
        self.layer.addSublayer(shapeLayer)
    }
}
