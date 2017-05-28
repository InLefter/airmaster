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
    
    @IBOutlet weak var time: UILabel!
    
    var detailData: Info!
    
    var pollutionInfos = Dictionary<Pollution, Array<PollutionSets>>()
    
//    var measureView = MeasureDetailViewController()
    
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
        
        let detailMeasureCellNib = UINib(nibName: "DetailMeasureCell", bundle: nil)
        self.detailTableView.register(detailMeasureCellNib, forCellReuseIdentifier: "DetailMeasureCellID")
        
        let dataCellNib = UINib(nibName: "DataSourceCell", bundle: nil)
        self.detailTableView.register(dataCellNib, forCellReuseIdentifier: "DataSourceCellID")
        
        if detailData != nil {
            navigationItem.title = detailData.name
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
    /// 城市 - 最近24小时信息
    /// 站点 - 最近24小时信息
    func getRecentData() {
        self.time.text = "更新时间：\(detailData.time?.toString() ?? "-")"
        
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
                let s = IndexSet.init(integer: 2)
                self.detailTableView.reloadSections(s, with: .fade)
            }
        })
    }
    
    func getDetailData(type: InfoType, code: String, name: String) {
        navigationItem.title = name
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
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return 4
        }
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
            loopAQICell.drawLoopLayer(aqi: CGFloat(aqi), quality: self.detailData.aqiQuality)
            loopAQICell.selectionStyle = UITableViewCellSelectionStyle.none
            return loopAQICell
        }else if indexPath.section == 1{
            let detailCell = tableView.dequeueReusableCell(withIdentifier: "DetailDataCellID", for: indexPath) as! DetailDataCell
            detailCell.setDetailDataView(pollutions: detailData.pollutionData)
            detailCell.selectionStyle = UITableViewCellSelectionStyle.none
            return detailCell
        }else if indexPath.section == 2{
            let measureCell = tableView.dequeueReusableCell(withIdentifier: "DetailMeasureCellID", for: indexPath) as! DetailMeasureCell
            let row = indexPath.row
            measureCell.configure(withDelegate: MeasureInfoCellModel(info: detailData.measureInfos[row], row: row))
            measureCell.selectionStyle = UITableViewCellSelectionStyle.none
            return measureCell
        }else if indexPath.section == 3{
            let chartCell = tableView.dequeueReusableCell(withIdentifier: "ChartCellID", for: indexPath) as! ChartCell
            chartCell.allDatas = pollutionInfos
            chartCell.selectPollution(type: Pollution.aqi)
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
        if indexPath.section == 2 {
            let measureView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MeasureDetailViewControllerID") as! MeasureDetailViewController
            measureView.modalPresentationStyle = .popover
            measureView.popoverPresentationController?.delegate = self
            measureView.popoverPresentationController?.sourceRect = CGRect(origin: CGPoint(x: self.view.frame.width / 2, y: 0), size: CGSize.zero)
            measureView.popoverPresentationController?.sourceView = tableView.cellForRow(at: indexPath)
            measureView.preferredContentSize = CGSize(width: 200, height: 200)
            measureView.popoverPresentationController?.permittedArrowDirections = .down
            self.present(measureView, animated: true, completion: {
                measureView.detailText.text = self.detailData.measureInfos[indexPath.row].detailText
            })
        }
    }
}

extension DetailViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
