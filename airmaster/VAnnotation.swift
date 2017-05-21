//
//  VAnnotation.swift
//  airmaster
//
//  Created by Howie on 2017/5/13.
//  Copyright © 2017年 Howie. All rights reserved.
//

import Foundation
import MapKit

class VAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D

    var type: InfoType
    var title: String?
    
    var info: Info
    
    var pollution = Dictionary<Pollution, (value: String, color: CGColor)>()
    
    init(coordinate: CLLocationCoordinate2D, type: InfoType, info: Info) {
        self.coordinate = coordinate

        self.type = type
        self.info = info
        
        if type == .city {
            self.title = info.area
        } else {
            self.title = info.name
        }
        
        for item in info.pollutionData {
            pollution.updateValue(("\(item.value)", PollutionColor[item.quality]!), forKey: item.name)
        }
        pollution.updateValue(("\(info.aqi!)", PollutionColor[info.aqiQuality]!), forKey: .aqi)
    }
}
