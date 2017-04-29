//
//  ChartCell.swift
//  airmaster
//
//  Created by Howie on 2017/4/29.
//  Copyright © 2017年 Howie. All rights reserved.
//

import UIKit
import Charts

class ChartCell: UITableViewCell {

    @IBOutlet weak var chartView: BarChartView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setChartView() {
        let xAxis = ["5","6","7","8"]
        let value = [20,30,40,25]
        var data: [BarChartDataEntry] = []
        
        for i in 0..<xAxis.count {
            let d = BarChartDataEntry(x: Double(i), y: Double(value[i]))
            data.append(d)
        }
        
        let dataSet = BarChartDataSet(values: data, label: nil)

        let barChartData = BarChartData(dataSet: dataSet)
        chartView.data = barChartData
        chartView.chartDescription?.text = "Sl"
        chartView.legend.enabled = false
        chartView.drawValueAboveBarEnabled = true

        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xAxis)
        chartView.xAxis.granularity = 1.0
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.drawGridLinesEnabled = false
        
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.rightAxis.drawAxisLineEnabled = false
        chartView.rightAxis.enabled = false
        
        chartView.scaleXEnabled = false
        chartView.scaleYEnabled = false
        
        chartView.animate(xAxisDuration: 1.0, easingOption: .easeInCirc)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
