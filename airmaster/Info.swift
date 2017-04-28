//
//  Info.swift
//  airmaster
//
//  Created by Howie on 2017/4/26.
//  Copyright © 2017年 Howie. All rights reserved.
//

import Foundation
import SwiftyJSON

enum Pollution: String {
    case o3 = "O3"
    case pm10 = "PM10"
    case pm2_5 = "PM2.5"
    case co = "CO"
    case no2 = "NO2"
    case so2 = "SO2"
}

class Info: NSObject {
    
    /// 各污染物标准值
    /// 单位：
    /// o3 μg/m³
    /// pm10 μg/m³
    /// pm2_5 μg/m³
    /// co mg/m³
    /// no2 μg/m³
    /// so2 μg/m³
    static let pollutionLimits = [Pollution.o3: 160, Pollution.pm10: 50, Pollution.pm2_5: 35, Pollution.co: 4000, Pollution.no2: 200, Pollution.so2: 500]
    
    // 名字
    var name: String?
    
    var pollutionData = Dictionary<Pollution, Int>()
    
    // aqi数值
    var aqi: Int?
    // 数据更新时间
    var time: Date?
    // 主要污染物
    var primaryPollution: String?
    // 空气质量
    var quality: String?
    // 建议
    var measure: String?
    // 空气状况
    var unhealthful: String?
    
    // 字典-主要污染物(排序)
    var sortedPollution = Array<(Pollution, Int)>()
    
    /// 污染物偏离值从小到大排序
    func mainTriPollution() {
        var tmp = Dictionary<Pollution, Float>()

        for (key, _) in Info.pollutionLimits {
            
            if let pollution = self.pollutionData[key] {
                tmp[key] = Float((pollution - Info.pollutionLimits[key]!) / Info.pollutionLimits[key]!)
            }
        }
        
        let sortedResult = tmp.sorted(){
            $0.1 < $1.1
        }
        
        for index in sortedResult {
            self.sortedPollution.append((index.key,(self.pollutionData[index.key])!))
        }

    }
}

class CityInfo: Info {
    // 城市编码
    var cityCode: String?
    
    init(city: JSON) {
        super.init()
        
        self.name = city["Area"].string
        self.cityCode = city["CityCode"].string
        
        self.pollutionData[.co] = Int(city["CO"].float! * 1000)
        self.pollutionData[.so2] = city["SO2"].int
        self.pollutionData[.no2] = city["NO2"].int
        self.pollutionData[.pm10] = city["PM10"].int
        self.pollutionData[.pm2_5] = city["PM2_5"].int
        self.pollutionData[.o3] = city["O3"].int
        
        self.aqi = city["AQI"].int
        self.time = DateFormatter.formatDate(date: city["Time"].string)
        self.quality = city["Quality"].string
        self.measure = city["Measute"].string
        self.unhealthful = city["Unhealthful"].string

        self.mainTriPollution()
    }
}

class SiteInfo: Info {
    // 站点所属城市
    var area: String?
    // 站点编码
    var siteCode: String?
    // 纬度
    var latitude: Float?
    // 经度
    var longitude: Float?
    
    init(site: JSON) {
        super.init()
        
        self.name = site["PositionName"].string
        self.area = site["Area"].string
        self.siteCode = site["StationCode"].string
        
        self.pollutionData[.co] = Int(site["CO"].float! * 1000)
        self.pollutionData[.so2] = site["SO2"].int
        self.pollutionData[.no2] = site["NO2"].int
        self.pollutionData[.pm10] = site["PM10"].int
        self.pollutionData[.pm2_5] = site["PM2_5"].int
        self.pollutionData[.o3] = site["O3"].int
        
        self.aqi = site["AQI"].int
        self.latitude = site["Latitude"].float
        self.longitude = site["Longitude"].float
        self.time = DateFormatter.formatDate(date: site["Time"].string)
        self.quality = site["Quality"].string
        self.measure = site["Measute"].string
        self.unhealthful = site["Unhealthful"].string
        
        self.mainTriPollution()
    }
}
