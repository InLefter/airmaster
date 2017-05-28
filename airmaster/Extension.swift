//
//  Extension.swift
//  airmaster
//
//  Created by Howie on 2017/4/26.
//  Copyright © 2017年 Howie. All rights reserved.
//
import UIKit
import Foundation
import MapKit

// MARK: - 获取日期的小时数
extension Date{
    func getHour() ->String {
        let calendar = Calendar.current
        let com = calendar.dateComponents([.day,.hour], from: self)
        return "\(com.hour!)"
    }
    
    func formatStamp() -> String {
        let date = Date()
        let now = Int(date.getHour())!
        let hour = Int(getHour())!
        
        var timeStr = ""
        if now < hour {
            timeStr += "昨天 "
        } else {
            timeStr += "今天 "
        }
        if hour < 12 {
            timeStr += "上午"
        } else {
            timeStr += "下午"
        }
        return timeStr + getHour() + ":00"
    }
    
    func toString() -> String {
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dformatter.string(from: self)
    }
}

// MARK: - 字符串-时间 格式化
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
//    static var thinGray = UIColor(red: 232 / 250, green: 232 / 250, blue: 232 / 250, alpha: 1)
    
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

extension String {
    func containChinese() -> Bool {
        return self.range(of: "\\p{Han}", options: .regularExpression) != nil
    }
    
    func chineseToPinyin() -> String {
        let sRef = NSMutableString(string: self) as CFMutableString
        CFStringTransform(sRef,nil, kCFStringTransformToLatin, false)
        CFStringTransform(sRef, nil, kCFStringTransformStripCombiningMarks, false)
      
        return sRef as String
    }
    
    func firstCharacter() -> String {
        let arr = self.components(separatedBy: " ")
        
        var ref = String()
        for first in arr {
            let index = first.index(first.startIndex, offsetBy: 1)
            ref += first.substring(to: index)
        }
        return ref
    }
    
    func rectWithConstrainedHeight(height: CGFloat, font: UIFont) -> CGRect {
        let constraintRect = CGSize(width: 0, height: height)
        let bouding = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return bouding
    }
}

extension MKCoordinateRegion {
    func isComprise(point: CLLocationCoordinate2D) -> Bool {
        let maxLat = center.latitude + span.latitudeDelta / 2
        let minLat = center.latitude - span.latitudeDelta / 2
        let maxLon = center.longitude + span.longitudeDelta / 2
        let minLon = center.longitude - span.longitudeDelta / 2
        if point.latitude <= maxLat && minLat <= point.latitude && minLon <= point.longitude && point.longitude <= maxLon {
            return true
        }
        return false
    }
}
