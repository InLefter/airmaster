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
    
    // 导航栏相关信息(省份、城市)
    var naviInfo: (String, String)!
    
    var searchResult = Array<SearchBrief>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false

        let searchAQICellNib = UINib(nibName: "SearchAQICell", bundle: nil)
        self.tableView.register(searchAQICellNib, forCellReuseIdentifier: "SearchAQICellID")
        
        let searchCellNib = UINib(nibName: "SearchCell", bundle: nil)
        tableView.register(searchCellNib, forCellReuseIdentifier: "SearchCellID")
        
        self.navigationItem.title = naviInfo.1
        self.navigationItem.leftBarButtonItem?.title = naviInfo.0
        
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
        if searchType == .city && !searchResult.isEmpty {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchType == .city && section  == 0 {
            return 1
        } else {
            return searchResult.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchType == .city && indexPath.section == 0 {
            let searchCell = tableView.dequeueReusableCell(withIdentifier: "SearchCellID", for: indexPath) as! SearchCell
            searchCell.name.text = naviInfo.1
            searchCell.selectionStyle = .none
            return searchCell
        }
        
        let searchAQICell = tableView.dequeueReusableCell(withIdentifier: "SearchAQICellID", for: indexPath) as! SearchAQICell
        if searchType != .city {
            searchAQICell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
        searchAQICell.name.text = searchResult[indexPath.row].name
        searchAQICell.aqi.text = searchResult[indexPath.row].value
        searchAQICell.aqi.layer.backgroundColor = searchResult[indexPath.row].aqiColor
        searchAQICell.selectionStyle = .none
        return searchAQICell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchType == .province {
            let desVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchAQIControllerID") as! SearchAQIController
            desVC.searchType = .city
            desVC.id = searchResult[indexPath.row].code
            desVC.naviInfo = (naviInfo.1, searchResult[indexPath.row].name)
            self.navigationController?.pushViewController(desVC, animated: true)
        } else if indexPath.section == 0 {
            if Cache.isAdd {
                self.navigationController?.dismiss(animated: true, completion: nil)
                Cache.setCollectedInfos(element: (searchType, id))
                Cache.isAdd = false
            } else {
                let detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewControllerID") as! DetailViewController
                detailViewController.getDetailData(type: searchType, code: id)
                self.navigationController?.pushViewController(detailViewController, animated: true)
            }
        }else {
            if Cache.isAdd {
                self.navigationController?.dismiss(animated: true, completion: nil)
                Cache.setCollectedInfos(element: (searchType.nextType(), searchResult[indexPath.row].code))
                Cache.isAdd = false
            } else {
                let detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewControllerID") as! DetailViewController
                detailViewController.getDetailData(type: searchType.nextType(), code: searchResult[indexPath.row].code)
                detailViewController.navigationItem.title = searchResult[indexPath.row].name
                self.navigationController?.pushViewController(detailViewController, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        view.tintColor = UIColor(red: 232 / 250, green: 232 / 250, blue: 232 / 250, alpha: 1)
    }
}
