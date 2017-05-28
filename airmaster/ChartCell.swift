//
//  ChartCell.swift
//  airmaster
//
//  Created by Howie on 2017/4/29.
//  Copyright © 2017年 Howie. All rights reserved.
//

import UIKit
import Charts

class ChartCell: UITableViewCell, UIPopoverPresentationControllerDelegate, PollutionPickerProtocol {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var chartView: BarChartView!
    
    var detailVC: DetailViewController!
    
    var pickerView = PollutionPickerController()
    
    // 数据集
    var allDatas = Dictionary<Pollution, Array<PollutionSets>>()
    
    @IBAction func changePollution(_ sender: Any) {
        pickerView.modalPresentationStyle = .popover
        pickerView.popoverPresentationController?.delegate = self
        pickerView.popoverPresentationController?.sourceRect = CGRect.zero
        pickerView.popoverPresentationController?.sourceView = button
        pickerView.preferredContentSize = CGSize(width: 200, height: 200)
        pickerView.popoverPresentationController?.permittedArrowDirections = .down
        pickerView.delegate = self
        detailVC.present(pickerView, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.button.backgroundColor = UIColor(dex: 0xdfdfdf)
        
        chartView.legend.enabled = false
        chartView.drawValueAboveBarEnabled = true
        chartView.noDataText = ""
        chartView.chartDescription?.text = ""
        
        chartView.xAxis.granularity = 1.0
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.drawGridLinesEnabled = false
        
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.rightAxis.drawAxisLineEnabled = false
        chartView.rightAxis.enabled = false
        chartView.scaleXEnabled = false
        chartView.scaleYEnabled = false
        
        chartView.dragEnabled = true
        chartView.dragDecelerationEnabled = true
    }
    
    func selectPollution(type: Pollution) {
        
        self.button.setTitle(type.rawValue, for: .normal)
        
        guard let tmp = allDatas[type] else {
            return
        }
        
        // 按时间排序(从小到大)
        let data = tmp.sorted(){
            $0.time < $1.time
        }
        
        var x = Array<String>()
        var y = Array<Int>()
        
        for index in data{
            x.append(index.time.getHour()+"h")
            y.append(index.value)
        }
        
        var dataEntry: [BarChartDataEntry] = []
        
        for i in 0..<x.count {
            let d = BarChartDataEntry(x: Double(i), y: Double(y[i]))
            dataEntry.append(d)
        }

        let dataSet = BarChartDataSet(values: dataEntry, label: nil)
        
        // data set自身有一个值
        // 尚不知道为什么
        dataSet.colors.removeAll()
        for index in data {
            dataSet.colors.append(UIColor(cgColor: PollutionColor[index.quality]!))
        }
        
        dataSet.highlightEnabled = false
        
        let barChartData = BarChartData(dataSet: dataSet)

        barChartData.setValueFormatter(ChartValueFormatter())
        chartView.data = barChartData
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: x)
        
        chartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
