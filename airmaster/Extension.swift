//
//  Extension.swift
//  airmaster
//
//  Created by Howie on 2017/4/26.
//  Copyright © 2017年 Howie. All rights reserved.
//

import Foundation

extension DateFormatter{
    open static func formatDate(date: String?) -> Date {
        let dateFormatter = DateFormatter()
        print(date!)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: date!)!
    }
}
