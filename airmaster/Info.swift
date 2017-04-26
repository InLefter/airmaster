//
//  Info.swift
//  airmaster
//
//  Created by Howie on 2017/4/26.
//  Copyright © 2017年 Howie. All rights reserved.
//

import Foundation
import SwiftyJSON

class Info: NSObject {
    // 名字
    var name: String?
    // so2浓度
    var so2: Int?
    // no2浓度
    var no2: Int?
    // pm10浓度
    var pm10: Int?
    // pm2.5浓度
    var pm2_5: Int?
    // o3浓度
    var o3: Int?
    // co浓度
    var co: Float?
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
}

class CityInfo: Info {
    // 城市编码
    var cityCode: String?
    
    init(city: JSON) {
        super.init()
        
        self.name = city["Area"].string
        self.cityCode = city["CityCode"].string
        self.so2 = city["SO2"].int
        self.no2 = city["NO2"].int
        self.pm10 = city["PM10"].int
        self.o3 = city["O3"].int
        self.pm2_5 = city["PM2_5"].int
        self.co = city["CO"].float
        self.aqi = city["AQI"].int
        self.time = DateFormatter.formatDate(date: city["Time"].string)
        self.quality = city["Quality"].string
        self.measure = city["Measute"].string
        self.unhealthful = city["Unhealthful"].string
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
        self.so2 = site["SO2"].int
        self.no2 = site["NO2"].int
        self.pm10 = site["PM10"].int
        self.o3 = site["O3"].int
        self.pm2_5 = site["PM2_5"].int
        self.co = site["CO"].float
        self.aqi = site["AQI"].int
        self.latitude = site["Latitude"].float
        self.longitude = site["Longitude"].float
        self.time = DateFormatter.formatDate(date: site["Time"].string)
        self.quality = site["Quality"].string
        self.measure = site["Measute"].string
        self.unhealthful = site["Unhealthful"].string
    }
}
