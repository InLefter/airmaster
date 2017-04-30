//
//  APIRequest.swift
//  airmaster
//
//  Created by Howie on 2017/4/26.
//  Copyright © 2017年 Howie. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct RequestData {
    static let url = "http://115.159.145.214"
    static let headers = ["Content-Type": "application/x-www-form-urlencoded"]
}

class APIResponse: NSObject {
    // 接受数据成功标志
    var isSuccess: Bool = false
    
    // 接收到的数据
    var dict: Dictionary<String,String>?
    
    // JSON
    var json: JSON?
    
    // 错误信息
    var error: Error?
}


typealias DataDeal = (APIResponse) -> Void


class APIRequest: NSObject {
    
    open static func post(path: RequestPath, parameters: Dictionary<String, String>?, complete: @escaping DataDeal){
        Alamofire.request(RequestData.url + path.rawValue, method: .post, parameters: parameters, headers: RequestData.headers).responseJSON{ (response) in
            let apiResponse = APIResponse()
            apiResponse.isSuccess = response.result.isSuccess
            apiResponse.json = JSON(data: response.data!)
            print(apiResponse.isSuccess,apiResponse.json!)
            complete(apiResponse)
        }
    }
}
