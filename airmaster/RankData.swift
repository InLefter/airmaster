//
//  RankData.swift
//  airmaster
//
//  Created by Howie on 2017/5/5.
//  Copyright © 2017年 Howie. All rights reserved.
//

import Foundation
import SwiftyJSON

class RankData: NSObject {
    
    var range: String!
    var name: String!
    var code: String!
    var value: String!
    var province: String!
    var type: Pollution!
    
    var valueColor: CGColor!
    
    init(type: Pollution, json: JSON) {
        if let index = json["range"].int {
            self.range = "\(index+1)"
        }
        self.name = json["name"].string
        self.code = json["code"].string
        self.province = json["province"].string
        self.type = type
        
        let tmp: Int
        if type == .co {
            tmp = Int(json["value"].float! * 1000)
        } else {
            tmp = json["value"].int!
        }
        self.value = "\(String(describing: tmp))"
        self.valueColor = PollutionColor[Pollution.quality(pollution: type, value: tmp)]
    }
}
