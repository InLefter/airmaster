//
//  Request.swift
//  airmaster
//
//  Created by Howie on 2017/4/25.
//  Copyright © 2017年 Howie. All rights reserved.
//

import Foundation
import SwiftyJSON

// API - 请求Path
enum RequestPath: String {
    case NearByInfo = "/api/latest"
    case LatestSiteInfo = "/api/site/latest"
    case LatestCityInfo = "/api/city/latest"
    case CityDayInfo = "/api/city/24h"
    case SiteDayInfo = "/api/site/24h"
    case CityAllSitesInfo = "api/city/allsites"
    
    case SearchProvince = "/api/search/province"
    case SearchCity = "/api/search/city"
}

typealias DirectHandler = (Bool, Array<Info>) -> Void

class Request: NSObject {

    /// 获取所属城市以及距离最近站点信息
    ///
    /// - Parameters:
    ///   - parameters: 网络请求Body
    ///   - complete: 城市/站点信息字典
    open static func getNearByInfo(parameters: Dictionary<String, String>?, complete: @escaping DirectHandler) {
        var nearbyInfo = Array<Info>()
        APIRequest.post(path: .NearByInfo, parameters: parameters, complete: { (response) in
            if response.isSuccess {
                // 请求成功
                
                let json = response.json!
                
                var infoType: InfoType = .city
                if json["nearby"][0]["CityCode"].int != nil {
                    infoType = .city
                }
                let cityInfo = Info(type: infoType, detail: json["nearby"][0]["Detail"])
                nearbyInfo.append(cityInfo)
                
                if json["nearby"][1]["StationCode"].string != nil {
                    infoType = .site
                }
                let siteInfo = Info(type: infoType, detail: json["nearby"][1]["Detail"])
                nearbyInfo.append(siteInfo)
            } else {
                // 请求失败
                
            }
            complete(response.isSuccess, nearbyInfo)
        })
    }
    
    /// 获取城市/站点最近24小时
    ///
    /// - Parameters:
    ///   - type: 城市/站点
    ///   - code: 城市/站点编码
    open static func getDayInfo(type: InfoType, code: String?, complete: @escaping DirectHandler){
  
        let pathType: RequestPath = type == .site ? .SiteDayInfo : .CityDayInfo
        let para = [type.rawValue: code] as! Dictionary<String, String>
        
        var oneDayInfo = Array<Info>()
        APIRequest.post(path: pathType, parameters: para, complete: { (response) in
            if response.isSuccess {
                // 请求成功
                let json = response.json!
                let hours = json["Detail"].array
                for hour in hours!{
                    let hourInfo = Info(type: type, detail: hour)
                    oneDayInfo.append(hourInfo)
                }
                
            } else {
                // 请求失败
                
            }
            complete(response.isSuccess, oneDayInfo)
        })
    }
    
    /// 获取城市最近一个月数据
    ///
    /// - Parameters:
    ///   - parameters: 请求Body
    ///   - complete: 请求完成闭包
    open static func getCityMonthInfo(parameters: Dictionary<String, String>?, complete: @escaping DirectHandler) {
        var oneMonthInfo = Array<Info>()
        APIRequest.post(path: .CityDayInfo, parameters: parameters, complete: { (response) in
            if response.isSuccess {
                // 请求成功
                let json = response.json!
                
                let cities = json["Detail"].array
                for city in cities!{
                    let cityInfo = Info(type: InfoType.city, detail: city)
                    oneMonthInfo.append(cityInfo)
                }
                
            } else {
                // 请求失败
                
            }
            complete(response.isSuccess, oneMonthInfo)
        })
    }
    
    /// 搜索返回简要信息 - 只含有实时AQI
    ///
    /// - Parameters:
    ///   - type: 省份/城市
    ///   - code: 省份/城市编码
    ///   - complete: 请求完成闭包
    open static func getSearchAQI(type: InfoType, code: String?, complete: @escaping (Bool, Array<SearchBrief>) -> Void){
        let pathType: RequestPath = type == .province ? .SearchProvince : .SearchCity
        let para = [type.rawValue: code] as! Dictionary<String, String>
        
        var searchResult = Array<SearchBrief>()
        APIRequest.post(path: pathType, parameters: para, complete: { (response) in
            if response.isSuccess {
                let json = response.json!
                let cities = json["Detail"].array
                if cities == nil {
                    searchResult.append(SearchBrief(unit: json["Detail"], type: type))
                } else {
                    for city in cities! {
                        let cityInfo = SearchBrief(unit: city, type: type)
                        searchResult.append(cityInfo)
                    }
                }
            } else {
                // 请求失败
            }
            complete(response.isSuccess, searchResult)
        })
    }
    
    open static func getPublishData(type: InfoType, code: String?, complete: @escaping (Bool, Info) -> Void){
        let pathType: RequestPath = type == .city ? .LatestCityInfo : .LatestSiteInfo
        
        var latest: Info!
        let para = [type.rawValue: code] as! Dictionary<String, String>
        APIRequest.post(path: pathType, parameters: para, complete: { (response) in
            if response.isSuccess {
                let json = response.json!
                latest = Info(type: type, detail: json["Detail"])
            } else {
                //
            }
            complete(response.isSuccess, latest)
        })
        
    }
}
