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

}
