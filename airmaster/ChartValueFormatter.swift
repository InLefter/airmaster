//
//  ChartValueFormatter.swift
//  airmaster
//
//  Created by Howie on 2017/5/28.
//  Copyright © 2017年 Howie. All rights reserved.
//

import Foundation
import Charts

public class ChartValueFormatter: NSObject, IValueFormatter {
    
    private var mFormat: NumberFormatter!
    
    public override init() {
        mFormat = NumberFormatter()
        mFormat.numberStyle = .none
    }
    
    public func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return (mFormat.number(from: String(value))?.description)!
    }
}
