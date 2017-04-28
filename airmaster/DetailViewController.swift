//
//  DetailViewController.swift
//  airmaster
//
//  Created by Howie on 2017/4/27.
//  Copyright © 2017年 Howie. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailTableView: UITableView!
    
    var detailData = Info()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.detailTableView.estimatedRowHeight = 100
        self.detailTableView.rowHeight = UITableViewAutomaticDimension

        let loopCellNib = UINib(nibName: "LoopAQICell", bundle: nil)
        self.detailTableView.register(loopCellNib, forCellReuseIdentifier: "LoopAQICellID")
        
        let detailCellNib = UINib(nibName: "DetailDataCell", bundle: nil)
        self.detailTableView.register(detailCellNib, forCellReuseIdentifier: "DetailDataCellID")
        
        let dataCellNib = UINib(nibName: "DataSourceCell", bundle: nil)
        self.detailTableView.register(dataCellNib, forCellReuseIdentifier: "DataSourceCellID")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 2:
            return 2
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let loopAQICell = tableView.dequeueReusableCell(withIdentifier: "LoopAQICellID", for: indexPath) as! LoopAQICell
            guard let aqi = self.detailData.aqi else {
                return loopAQICell
            }
            loopAQICell.AQI.text = String(describing: aqi)
            loopAQICell.loopView.drawLoopLayer(aqi: CGFloat(aqi))
            loopAQICell.quality.text = self.detailData.quality
            return loopAQICell
        }else if indexPath.section == 1{
            let detailCell = tableView.dequeueReusableCell(withIdentifier: "DetailDataCellID", for: indexPath) as! DetailDataCell
            return detailCell
        }else{
            let dataSourceCell = tableView.dequeueReusableCell(withIdentifier: "DataSourceCellID", for: indexPath) as! DataSourceCell
            return dataSourceCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
    
}
