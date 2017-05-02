//
//  DataModel.swift
//  airmaster
//
//  Created by Howie on 2017/5/2.
//  Copyright © 2017年 Howie. All rights reserved.
//

import Foundation

class DataModel: NSObject {
    
    static func provinceData() -> Array<(String, String)> {
        let path = Bundle.main.path(forResource: "Province", ofType: "plist")
        let array = NSArray(contentsOfFile: path!)
        
        var result = Array<(String, String)>()
        for ele in array! {
            let dict = ele as! NSMutableDictionary
            let key = dict["name"]! as! String
            let pair = (key,dict["pid"] as? String)
            result.append(pair as! (String, String))
        }
        return result
    }
    
    static func searchData() -> Array<(InfoType, String, String)> {
        let path = Bundle.main.path(forResource: "City", ofType: "plist")
        let array = NSArray(contentsOfFile: path!)
        
        var result = Array<(InfoType, String, String)>()
        for city in array! {
            let dict = city as! NSMutableDictionary
            let key = dict["cityName"]! as! String
            let tmp = (InfoType.city, key, dict["cityID"] as? String)
            result.append(tmp as! (InfoType, String, String))
        }
        
        let sitePath = Bundle.main.path(forResource: "City", ofType: "plist")
        let siteArray = NSArray(contentsOfFile: sitePath!)
        
        for site in siteArray! {
            let dict = site as! NSMutableDictionary
            let key = dict["siteName"]! as! String
            let tmp = (InfoType.site, key, dict["siteID"] as? String)
            result.append(tmp as! (InfoType, String, String))
        }
        return result
    }
}
