//
//  MeasureData.swift
//  airmaster
//
//  Created by Howie on 2017/5/24.
//  Copyright © 2017年 Howie. All rights reserved.
//

import Foundation

enum MeasureItem: String {
    case OldChild = "老人与儿童"
    case OpenWindows = "开窗通风"
    case WearMask = "口罩"
    case OutdoorSport = "户外运动"
}

enum MeasureLevel: Int {
    case good = 0x00ff00
    case fair = 0xd2dd29
    case bad = 0xcc0000
}

struct MeasureInfo {
    var text: String
    var detailText: String
    var level: MeasureLevel
    init(text: String, detailText: String, level: MeasureLevel) {
        self.text = text
        self.detailText = detailText
        self.level = level
    }
    
    
    static let OldChild = [MeasureLevel.good:(text: "适宜户外运动", detailText: "空气质量很好，对老人与儿童的健康没有危害，无需特殊防护。"),
                           MeasureLevel.fair:(text: "减少户外运动", detailText: "老人与儿童外出时应考虑佩戴口罩，避免长时间、高强度的户外活动，特别是交通繁忙的地方。"),
                           MeasureLevel.bad:(text: "避免户外活动", detailText: "空气污染严重，对老人与儿童的健康会产生严重不利影响，应当避免户外活动，停留在室内关闭门窗并开启空气净化器，如果一定需要外出请务必佩戴口罩。")]
    
    static let OpenWindow = [MeasureLevel.good:(text: "适宜开窗", detailText: "空气质量很好，有利于污染物的扩散，适宜开窗通风。"),
                            MeasureLevel.fair:(text: "可以开窗", detailText: "可以开窗通风。但老人和儿童以及敏感人群可能会感受到一些不适症状，对于他们不适合长时间开窗通风。"),
                            MeasureLevel.bad:(text: "建议关窗", detailText: "非常不适合开窗通风，请紧闭门窗。如果开窗会对老人与儿童，体弱者、呼吸道与心肺疾病患者的健康有严重影响。")]
    
    static let WearMask = [MeasureLevel.good:(text: "不用佩戴", detailText: "空气质量很好，不需要佩戴口罩。"),
                           MeasureLevel.fair:(text: "建议佩戴", detailText: "出行时建议佩戴口罩，特别是老人与儿童，体弱者或心脏病、呼吸系统疾病患者。"),
                           MeasureLevel.bad:(text: "需要佩戴", detailText: "空气污染严重，主要污染物浓度较高，对各类人群的健康都有严重影响，出行时请务必佩戴口罩，特别是老人与儿童，体弱者或心脏病、呼吸系统疾病患者。")]
    
    static let OutdoorSport = [MeasureLevel.good:(text: "适宜", detailText: "空气质量很好，非常适合进行户外运动。"),
                               MeasureLevel.fair:(text: "不建议", detailText: "敏感人群的症状会轻度加剧，应避免户外运动。健康人群开始出现刺激症状，对心脏和呼吸系统开始产生影响，应减少户外运动。"),
                               MeasureLevel.bad:(text: "不适宜", detailText: "敏感人群、心脏病或肺病患者的症状显著加剧，应当留在室内避免体力消耗。健康人群会普遍出现不适症状，应当避免户外运动，防止空气污染对身体的损伤。")]
}
