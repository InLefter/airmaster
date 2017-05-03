//
//  DetailViewController.swift
//  airmaster
//
//  Created by Howie on 2017/4/27.
//  Copyright © 2017年 Howie. All rights reserved.
//

import UIKit

struct PollutionSets {
    var time: Date = Date()
    var value: Int = 0
    var quality: PollutionQuality = .noValue
}

class DetailViewController: UIViewController {

    @IBOutlet weak var detailTableView: UITableView!
    
    var detailData: Info!
    
    var pollutionInfos = Dictionary<Pollution, Array<PollutionSets>>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.detailTableView.estimatedRowHeight = 100
        self.detailTableView.rowHeight = UITableViewAutomaticDimension
        self.automaticallyAdjustsScrollViewInsets = false

        let loopCellNib = UINib(nibName: "LoopAQICell", bundle: nil)
        self.detailTableView.register(loopCellNib, forCellReuseIdentifier: "LoopAQICellID")
        
        let detailCellNib = UINib(nibName: "DetailDataCell", bundle: nil)
        self.detailTableView.register(detailCellNib, forCellReuseIdentifier: "DetailDataCellID")
        
        let chartCellNib = UINib(nibName: "ChartCell", bundle: nil)
        self.detailTableView.register(chartCellNib, forCellReuseIdentifier: "ChartCellID")
        
        let dataCellNib = UINib(nibName: "DataSourceCell", bundle: nil)
        self.detailTableView.register(dataCellNib, forCellReuseIdentifier: "DataSourceCellID")
        
        if detailData != nil {
            getRecentData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension DetailViewController {
    /// 获取数据集
    /// 城市 - 最近1个月信息
    /// 站点 - 最近24小时信息
    func getRecentData() {
        Request.getDayInfo(type: detailData.type, code: detailData.code, complete: { success, infos in
            if success {
                for info in infos {
                    // 污染物数据
                    for i in 0..<info.pollutionData.count {
                        let temp = PollutionSets(time: info.time!, value: info.pollutionData[i].value, quality: info.pollutionData[i].quality)
                        var tmp = self.pollutionInfos[info.pollutionData[i].name]
                        if tmp == nil {
                            tmp = Array<PollutionSets>()
                        }else{
                            tmp?.append(temp)
                        }
                        self.pollutionInfos.updateValue(tmp!, forKey: info.pollutionData[i].name)
                    }
                    
                    // AQI数据
                    let aqiTmp = PollutionSets(time: info.time!, value: info.aqi!, quality: info.aqiQuality)
                    var tmp = self.pollutionInfos[Pollution.aqi]
                    if tmp == nil {
                        tmp = Array<PollutionSets>()
                    } else {
                        tmp?.append(aqiTmp)
                    }
                    self.pollutionInfos.updateValue(tmp!, forKey: Pollution.aqi)
                }
                let s = IndexPath.init(row: 2, section: 0)
                self.detailTableView.reloadRows(at: [s], with: UITableViewRowAnimation.fade)
            }
        })
    }
    
    func getDetailData(type: InfoType, code: String) {
        Request.getPublishData(type: type, code: code, complete: { (isSuccess, latest) in
            if isSuccess {
                self.detailData = latest
                self.detailTableView.reloadData()
                self.getRecentData()
            } else {
                //
            }
        })
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if detailData == nil {
            return 0
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let loopAQICell = tableView.dequeueReusableCell(withIdentifier: "LoopAQICellID", for: indexPath) as! LoopAQICell
            guard let aqi = self.detailData.aqi else {
                return loopAQICell
            }
            loopAQICell.AQI.text = String(describing: aqi)
            loopAQICell.quality.text = self.detailData.quality
            loopAQICell.drawLoopLayer(aqi: CGFloat(aqi), quality: self.detailData.aqiQuality)
            loopAQICell.selectionStyle = UITableViewCellSelectionStyle.none
            return loopAQICell
        }else if indexPath.row == 1{
            let detailCell = tableView.dequeueReusableCell(withIdentifier: "DetailDataCellID", for: indexPath) as! DetailDataCell
            detailCell.setDetailDataView(pollutions: detailData.pollutionData)
            detailCell.selectionStyle = UITableViewCellSelectionStyle.none
            return detailCell
        }else if indexPath.row == 2{
            let chartCell = tableView.dequeueReusableCell(withIdentifier: "ChartCellID", for: indexPath) as! ChartCell
            chartCell.allDatas = pollutionInfos
            chartCell.setChartView(type: Pollution.aqi)
            chartCell.detailVC = self
            chartCell.selectionStyle = UITableViewCellSelectionStyle.none
            return chartCell
        }else{
            let dataSourceCell = tableView.dequeueReusableCell(withIdentifier: "DataSourceCellID", for: indexPath) as! DataSourceCell
            dataSourceCell.selectionStyle = UITableViewCellSelectionStyle.none
            return dataSourceCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
