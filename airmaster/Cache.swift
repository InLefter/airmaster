//
//  Cache.swift
//  airmaster
//
//  Created by Howie on 2017/4/27.
//  Copyright © 2017年 Howie. All rights reserved.
//

import Foundation

let SHARE_ITEM = ["我正在使用空气管家，实时查看全国各城市站点数据，你也来试试吧"]

// 由于TabBar嵌套着NavigationBar，所以搜索货增加的变量传值不易控制，则此处设了一个全局变量
class Cache: NSObject {
    static var isAdd = Bool()
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
    
    static func removeOne(id: String) {
        for i in 0..<collection.count {
            if collection[i].1 == id {
                collection.remove(at: i)
                break
            }
        }
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
    
    static func setCollectedInfos(element: (InfoType, String)){
        var type = Array<String>()
        var code = Array<String>()
        for index in collection {
            if element.1 == index.1 {
                return
            }
            type.append(index.0.rawValue)
            code.append(index.1)
        }
        collection.append(element)
        type.append(element.0.rawValue)
        code.append(element.1)
        defaults.set(type, forKey: "CollectedArrayType")
        defaults.set(code, forKey: "CollectedArrayCode")
        defaults.synchronize()
    }
}
