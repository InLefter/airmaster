//
//  SearchAQIController.swift
//  airmaster
//
//  Created by Howie on 2017/5/2.
//  Copyright © 2017年 Howie. All rights reserved.
//

import UIKit

class SearchAQIController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var searchType: InfoType!
    
    var id: String!
    
    var baseInfo: SearchBrief!
    
    var naviInfo: (String, String)!
    
    var searchResult = Array<SearchBrief>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false

        let searchAQICellNib = UINib(nibName: "SearchAQICell", bundle: nil)
        self.tableView.register(searchAQICellNib, forCellReuseIdentifier: "SearchAQICellID")
        
        self.navigationItem.title = naviInfo.1
        self.navigationItem.leftBarButtonItem?.title = naviInfo.0
        
//        if searchType == .province {
//            self.navigationItem.leftBarButtonItem =
//        }
        
        getSearchResult()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getSearchResult() {
        Request.getSearchAQI(type: searchType, code: id, complete: { isSuccess, results in
            if isSuccess {
                self.searchResult = results
                self.tableView.reloadData()
            } else {
                // 失败
            }
        })
    }
    
}

extension SearchAQIController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if searchType == .province {
            return 1
        }else{
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchType == .city && section == 0 {
            return 1
        }else{
            return searchResult.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchAQICell = tableView.dequeueReusableCell(withIdentifier: "SearchAQICellID", for: indexPath) as! SearchAQICell
        if searchType != .city {
            searchAQICell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
        if searchType == .city && indexPath.section == 0 {
            searchAQICell.name.text = baseInfo.name
            searchAQICell.aqi.text = baseInfo.value
            searchAQICell.aqi.layer.backgroundColor = baseInfo.aqiColor
        }else{
            searchAQICell.name.text = searchResult[indexPath.row].name
            searchAQICell.aqi.text = searchResult[indexPath.row].value
            searchAQICell.aqi.layer.backgroundColor = searchResult[indexPath.row].aqiColor
        }
        searchAQICell.selectionStyle = UITableViewCellSelectionStyle.none
        return searchAQICell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchType == .province {
            let desVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchAQIControllerID") as! SearchAQIController
            desVC.baseInfo = searchResult[indexPath.row]
            desVC.searchType = .city
            desVC.id = searchResult[indexPath.row].code
            desVC.naviInfo = (naviInfo.1, searchResult[indexPath.row].name)
            self.navigationController?.pushViewController(desVC, animated: true)
        } else {
            //
            // let detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewControllerID") as! DetailViewController
            // detailViewController.detailData = infos[indexPath.row]
            // self.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}
