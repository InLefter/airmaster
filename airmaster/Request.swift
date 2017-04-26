//
//  Request.swift
//  airmaster
//
//  Created by Howie on 2017/4/25.
//  Copyright © 2017年 Howie. All rights reserved.
//

import Foundation
import SwiftyJSON

enum RequestPath: String {
    case NearByInfo = "/api/latest"
    case LatestSiteInfo = "/api/site/latest"
    case LatestCityInfo = "/api/city/latest"
    case CityMonthInfo = "/api/city/month"
    case SiteDayInfo = "api/site/24h"
    case CityAllSitesInfo = "api/city/allsites"
}

typealias DirectHandler = (Bool, Array<Info>) -> Void

class Request: NSObject {
    
    /// 获取所属城市以及距离最近站点信息
    ///
    /// - Parameter parameters: 网络请求Body
    /// - Returns: 城市站点信息字典
    open static func getNearByInfo(parameters: Dictionary<String, String>?, complete: @escaping DirectHandler) {
        var nearbyInfo = Array<Info>()
        APIRequest.post(path: .NearByInfo, parameters: parameters, complete: { (response) in
            if response.isSuccess {
                // 请求成功
                
                let json = response.json!
                print(json)
                let city = json["nearby"][0]["Detail"]
                let site = json["nearby"][1]["Detail"]
                
                print(city)
                print(city["Time"])
                
                let cityInfo = CityInfo(city: city)
                let siteInfo = SiteInfo(site: site)
                
                nearbyInfo.append(cityInfo)
                nearbyInfo.append(siteInfo)
                
                complete(response.isSuccess, nearbyInfo)
            } else {
                // 请求失败
                
            }
        })
    }
    
    open static func getSiteDayInfo(parameters:Dictionary<String, String>?) -> Array<Info>? {
        var oneDayInfo = Array<Info>()
        APIRequest.post(path: .SiteDayInfo, parameters: parameters, complete: { (response) in
            if response.isSuccess {
                // 请求成功
                
                let json = JSON(response)
                let sites = json["Detail"].array
                
                for site in sites!{
                    let siteInfo = SiteInfo(site: site)
                    oneDayInfo.append(siteInfo)
                }
                
            } else {
                // 请求失败
                
            }
        })
        return oneDayInfo
    }
}
