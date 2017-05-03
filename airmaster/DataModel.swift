//
//  DataModel.swift
//  airmaster
//
//  Created by Howie on 2017/5/2.
//  Copyright © 2017年 Howie. All rights reserved.
//

import Foundation

typealias SearchType = (InfoType, String, String, String)

class DataModel: NSObject {
    
    static func provinceData() -> Array<SearchType> {
        let path = Bundle.main.path(forResource: "Province", ofType: "plist")
        let array = NSArray(contentsOfFile: path!)
        
        var result = Array<SearchType>()
        for ele in array! {
            let dict = ele as! NSMutableDictionary
            let key = dict["name"]! as! String
            let tmp = (InfoType.province, key, dict["pid"] as? String, "")
            result.append(tmp as! SearchType)
        }
        return result
    }
    
    static func searchData() -> Array<SearchType> {
        let path = Bundle.main.path(forResource: "City", ofType: "plist")
        let array = NSArray(contentsOfFile: path!)
        
        var result = Array<SearchType>()
        for city in array! {
            let dict = city as! NSMutableDictionary
            let key = dict["cityName"]! as! String
            let tmp = (InfoType.city, key, dict["cityID"] as? String, "")
            result.append(tmp as! SearchType)
        }
        
        let sitePath = Bundle.main.path(forResource: "Site", ofType: "plist")
        let siteArray = NSArray(contentsOfFile: sitePath!)
        
        for site in siteArray! {
            let dict = site as! NSMutableDictionary
            let key = dict["siteName"]! as! String
            let area = dict["city"]! as! String
            let tmp = (InfoType.site, key, dict["siteID"] as? String, area)
            result.append(tmp as! (InfoType, String, String, String))
        }
        return result
    }
}
