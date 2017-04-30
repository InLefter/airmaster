//
//  DetailViewController.swift
//  airmaster
//
//  Created by Howie on 2017/4/27.
//  Copyright © 2017年 Howie. All rights reserved.
//

import UIKit

typealias PollutionSets = Dictionary<Pollution, Dictionary<Date, Int>>

class DetailViewController: UIViewController {

    @IBOutlet weak var detailTableView: UITableView!
    
    var detailData: Info!
    
    var infos = Array<Info>()
    var pollutionInfos = PollutionSets()
    
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
        
        getRecentData()
    }
    
    /// 获取数据集
    /// 城市 - 最近1个月信息
    /// 站点 - 最近24小时信息
    func getRecentData() {
        switch detailData.type {
        case .city:
            let para = ["CityID": detailData.code] as! Dictionary<String, String>
            Request.getDayInfo(parameters: para, complete: { success, infos in
                if success {
                    for info in infos {
                        for i in 0..<info.pollutionData.count {
                            self.pollutionInfos[info.pollutionData[i].name]?[info.time!] = info.pollutionData[i].value
                        }
                    }
                }
            })
            break
        case .site:
            let para = ["SiteID": detailData.code] as! Dictionary<String, String>
            Request.getDayInfo(parameters: para, complete: { success, infos in
                if success {
                    for info in infos {
                        for i in 0..<info.pollutionData.count {
                            self.pollutionInfos[info.pollutionData[i].name]?[info.time!] = info.pollutionData[i].value
                        }
                    }
                }
            })
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let loopAQICell = tableView.dequeueReusableCell(withIdentifier: "LoopAQICellID", for: indexPath) as! LoopAQICell
            guard let aqi = self.detailData.aqi else {
                return loopAQICell
            }
            loopAQICell.AQI.text = String(describing: aqi)
            loopAQICell.quality.text = self.detailData.quality
            loopAQICell.drawLoopLayer(aqi: CGFloat(aqi), color: self.detailData.aqiColor!)
            loopAQICell.selectionStyle = UITableViewCellSelectionStyle.none
            return loopAQICell
        }else if indexPath.section == 1{
            let detailCell = tableView.dequeueReusableCell(withIdentifier: "DetailDataCellID", for: indexPath) as! DetailDataCell
            detailCell.setDetailDataView(pollutions: detailData.pollutionData)
            detailCell.selectionStyle = UITableViewCellSelectionStyle.none
            return detailCell
        }else if indexPath.section == 2{
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
