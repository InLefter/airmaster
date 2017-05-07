//
//  Cache.swift
//  airmaster
//
//  Created by Howie on 2017/4/27.
//  Copyright © 2017年 Howie. All rights reserved.
//

import Foundation

// 由于TabBar嵌套着NavigationBar，所以搜索货增加的变量传值不易控制，则此处设了一个全局变量
class Cache: NSObject {
    static var isAdd = false
    static var collection = Array<(InfoType, String)>()
    
    static let defaults = UserDefaults.standard
    
    static func getCollectedInfos() {
        
        if let typeTmp = defaults.array(forKey: "CollectedArrayType"),
            let codeArray = defaults.array(forKey: "CollectedArrayCode"){
            for i in 0..<typeTmp.count {
                collection.append((InfoType(rawValue: typeTmp[i] as! String)!, codeArray[i] as! String))
            }
        }
    }
    
    static func setCollectedInfos(element: (InfoType, String)){
        collection.append(element)
        var type = Array<String>()
        var code = Array<String>()
        for index in collection {
            type.append(index.0.rawValue)
            code.append(index.1)
        }
        defaults.set(type, forKey: "CollectedArrayType")
        defaults.set(code, forKey: "CollectedArrayCode")
        defaults.synchronize()
    }
}
