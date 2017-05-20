//
//  Info.swift
//  airmaster
//
//  Created by Howie on 2017/4/26.
//  Copyright © 2017年 Howie. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation
import SwiftyJSON

enum PollutionQuality: String {
    case noValue = "-"
    case good = "优"
    case fair = "良"
    case mildPolluted = "轻度污染"
    case moderatePolluted = "中度污染"
    case serverPolluted = "重度污染"
    case seriousPolluted = "严重污染"
    case burstTable = "爆表"
}

// 污染物质量-颜色对应表
let PollutionColor: Dictionary<PollutionQuality, CGColor> = [
    .good:              UIColor(dex: 0x00ff00).cgColor,
    .fair:              UIColor(dex: 0xd2dd29).cgColor,
    .mildPolluted:      UIColor(dex: 0xdd7e6b).cgColor,
    .moderatePolluted:  UIColor(dex: 0xcc0000).cgColor,
    .serverPolluted:    UIColor(dex: 0xd700d0).cgColor,
    .seriousPolluted:   UIColor(dex: 0x961900).cgColor,
    .burstTable:        UIColor(dex: 0x434343).cgColor,
    .noValue:           UIColor(dex: 0xffffff).cgColor
]

enum Pollution: String {
    case aqi = "AQI"
    case o3 = "O3"
    case pm10 = "PM10"
    case pm2_5 = "PM2.5"
    case co = "CO"
    case no2 = "NO2"
    case so2 = "SO2"
    
    // 污染物指数等级
    static func quality(pollution: Pollution, value: Int) -> PollutionQuality {
        if value < 0 {
            return .noValue
        }
        switch pollution {
        case .aqi:
            switch value {
            case 0...50:
                return .good
            case 51...100:
                return .fair
            case 101...150:
                return .mildPolluted
            case 151...200:
                return .moderatePolluted
            case 201...300:
                return .serverPolluted
            default:
                return .seriousPolluted
            }
        case .o3:
            switch value {
            case 0...160:
                return .good
            case 161...200:
                return .fair
            case 201...300:
                return .mildPolluted
            case 301...400:
                return .moderatePolluted
            case 401...800:
                return .serverPolluted
            default:
                return .seriousPolluted
            }
        case .pm10:
            switch value {
            case 0...50:
                return .good
            case 51...150:
                return .fair
            case 151...250:
                return .mildPolluted
            case 251...350:
                return .moderatePolluted
            case 351...420:
                return .serverPolluted
            case 421...600:
                return .seriousPolluted
            default:
                return .burstTable
            }
        case .pm2_5:
            switch value {
            case 0...35:
                return .good
            case 36...75:
                return .fair
            case 76...115:
                return .mildPolluted
            case 116...150:
                return .moderatePolluted
            case 151...250:
                return .serverPolluted
            case 251...500:
                return .seriousPolluted
            default:
                return .burstTable
            }
        case .no2:
            switch value {
            case 0...100:
                return .good
            case 101...200:
                return .fair
            case 201...700:
                return .mildPolluted
            case 701...1200:
                return .moderatePolluted
            case 1201...2340:
                return .serverPolluted
            default:
                return .seriousPolluted
            }
        case .co:
            switch value {
            case 0...5000:
                return .good
            case 5001...10000:
                return .fair
            case 10001...35000:
                return .mildPolluted
            case 350001...60000:
                return .moderatePolluted
            case 60001...90000:
                return .serverPolluted
            default:
                return .seriousPolluted
            }
        case .so2:
            switch value {
            case 0...150:
                return .good
            case 151...500:
                return .fair
            case 501...650:
                return .mildPolluted
            case 651...800:
                return .moderatePolluted
            case 801...1600:
                return .serverPolluted
            default:
                return .seriousPolluted
            }
        }
    }
}

enum InfoType: String {
    case province = "pid"
    case city = "CityID"
    case site = "SiteID"
    
    static func <(left: InfoType, right: InfoType) -> Bool {
        return left.hashValue < right.hashValue
    }
    
    func nextType() -> InfoType {
        switch self {
        case .province:
            return .city
        default:
            return .site
        }
    }
}

struct PollutionData {
    var name: Pollution
    var value: Int
    var quality: PollutionQuality
    
    init(name: Pollution, value: Int) {
        self.name = name
        self.value = value
        self.quality = Pollution.quality(pollution: name, value: value)
    }
}

struct SearchBrief {
    var name: String
    var code: String
    var value: String
    var aqiColor: CGColor
    
    init(unit: JSON, type: InfoType) {
        if type == .province {
            self.name = unit["Area"].string!
            self.code = unit["CityCode"].string!
        }else{
            self.name = unit["PositionName"].string!
            self.code = unit["SiteCode"].string!
        }
        
        
        guard let aqi = Int(unit["AQI"].string!) else {
            self.aqiColor = PollutionColor[.noValue]!
            self.value = "-"
            return
        }
        self.value = "AQI " + unit["AQI"].string!
        self.aqiColor = PollutionColor[Pollution.quality(pollution: .aqi, value: aqi)]!
    }
}

class Info: NSObject, NSCoding {
    
    /// 各污染物标准值
    /// 单位：
    /// o3 μg/m³
    /// pm10 μg/m³
    /// pm2_5 μg/m³
    /// co mg/m³
    /// no2 μg/m³
    /// so2 μg/m³

    // 名字
    var name: String?
    
    // 各污染物信息-数组(不包含AQI)
    var pollutionData = Array<PollutionData>()
    
    // aqi数值
    var aqi: Int?
    // aqi质量
    var aqiQuality: PollutionQuality
    
    // 数据更新时间
    var time: Date?
    
    // 空气质量
    var quality: String?
    
//    // 建议
//    var measure: String?
//    // 空气状况
//    var unhealthful: String?

    // 编码
    var code: String?
    
    // 站点所属城市
    var area: String?
    // 纬度
    var latitude: Float?
    // 经度
    var longitude: Float?
    
    // 类型
    var type: InfoType

    var coordinate: CLLocationCoordinate2D
    
    init(type: InfoType, detail: JSON) {

        self.type = type
        self.area = detail["Area"].string
        self.aqi = detail["AQI"].int

        self.aqiQuality = Pollution.quality(pollution: .aqi, value: aqi!)
        self.time = DateFormatter.formatDate(date: detail["Time"].string)
        self.quality = detail["Quality"].string

        self.coordinate = CLLocationCoordinate2D(latitude: detail["Latitude"].double!, longitude: detail["Longitude"].double!)
        
        switch type {
        case .city:
            self.name = area
            self.code = "\(detail["CityCode"].int ?? 0)"
            break
        case .site:
            self.name = detail["PositionName"].string
            self.code = detail["StationCode"].string
        default:
            break
        }
        
        self.pollutionData.append(PollutionData(name: .o3, value: detail["O3"].int!))
        self.pollutionData.append(PollutionData(name: .co, value: Int(detail["CO"].float! * 1000)))
        self.pollutionData.append(PollutionData(name: .so2, value: detail["SO2"].int!))
        self.pollutionData.append(PollutionData(name: .no2, value: detail["NO2"].int!))
        self.pollutionData.append(PollutionData(name: .pm10, value: detail["PM10"].int!))
        self.pollutionData.append(PollutionData(name: .pm2_5, value: detail["PM2_5"].int!))
        
        self.pollutionData = pollutionData.sorted(){
            $0.quality.hashValue > $1.quality.hashValue
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.pollutionData, forKey: "pollutionData")
        aCoder.encode(self.aqi, forKey: "name")
        aCoder.encode(self.aqiQuality, forKey: "aqiQuality")
        aCoder.encode(self.time, forKey: "time")
        aCoder.encode(self.quality, forKey: "quality")
        aCoder.encode(self.code, forKey: "code")
        aCoder.encode(self.area, forKey: "area")
        aCoder.encode(self.latitude, forKey: "latitude")
        aCoder.encode(self.longitude, forKey: "longitude")
        aCoder.encode(self.type, forKey: "type")
        aCoder.encode(self.coordinate, forKey: "coordinate")
    }
    
    required init?(coder aDecoder: NSCoder){
        self.name = aDecoder.decodeObject(forKey: "name") as? String
        self.pollutionData = aDecoder.decodeObject(forKey: "pollutionData") as! Array<PollutionData>
        self.aqi = aDecoder.decodeObject(forKey: "aqi") as? Int
        self.aqiQuality = aDecoder.decodeObject(forKey: "aqiQuality") as! PollutionQuality
        self.time = aDecoder.decodeObject(forKey: "time") as? Date
        self.quality = aDecoder.decodeObject(forKey: "quality") as? String
        self.code = aDecoder.decodeObject(forKey: "code") as? String
        self.area = aDecoder.decodeObject(forKey: "area") as? String
        self.longitude = aDecoder.decodeObject(forKey: "longitude") as? Float
        self.latitude = aDecoder.decodeObject(forKey: "latitude") as? Float
        self.type = aDecoder.decodeObject(forKey: "type") as! InfoType
        self.coordinate = aDecoder.decodeObject(forKey: "coordinate") as! CLLocationCoordinate2D
    }
}
