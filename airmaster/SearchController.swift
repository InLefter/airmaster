//
//  SearchController.swift
//  airmaster
//
//  Created by Howie on 2017/5/1.
//  Copyright © 2017年 Howie. All rights reserved.
//

import UIKit

class SearchController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func dismissVC(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    var provinceData = {DataModel.provinceData()}()
    lazy var searchData = {DataModel.searchData()}()
    
    // 取消全拼音搜索
    // 城市/站点拼音
//    lazy var searchDataPinyin = { () -> Array<String> in
//        var pinyin = Array<String>()
//        for index in self.searchData {
//            pinyin.append(index.1.chineseToPinyin())
//        }
//        return pinyin
//    }()
    
    // 城市/站点拼音首字母
    var searchField = Array<(key: String, value: Array<SearchType>)>()
    
    var searchResult = Array<SearchType>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        self.title = "搜索"
        self.tableView.estimatedRowHeight = 50
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        let searchResultCellNib = UINib(nibName: "SearchResultCell", bundle: nil)
        tableView.register(searchResultCellNib, forCellReuseIdentifier: "SearchResultCellID")
        
        let searchCellNib = UINib(nibName: "SearchCell", bundle: nil)
        tableView.register(searchCellNib, forCellReuseIdentifier: "SearchCellID")
        
        searchResult = provinceData
        
        DispatchQueue.global().async {
            self.setSearchDataFirst()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension SearchController {
    // 建立地点名拼音首字母索引
    func setSearchDataFirst() {
        var searchDataFirstChar = Dictionary<String, Array<SearchType>>()
        for each in self.searchData {
            let index = each.1.chineseToPinyin().firstCharacter()
            var arr = searchDataFirstChar[index]
            if arr == nil {
                arr = Array<SearchType>()
            }
            arr?.append(each)
            searchDataFirstChar[index] = arr
        }
        
        // 数据排序 - 城市->站点
        searchField = searchDataFirstChar.sorted(by: { p1, p2 in
            if p1.value[0].0 < p2.value[0].0 {
                return true
            } else {
                if p1.value[0].2 < p2.value[0].2 {
                    return true
                } else {
                    return false
                }
            }
        })
    }
}

extension SearchController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchResult[indexPath.row].0 == .site {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCellID", for: indexPath) as! SearchResultCell
            cell.name.text = searchResult[indexPath.row].1
            cell.area.text = searchResult[indexPath.row].3
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCellID", for: indexPath) as! SearchCell
            cell.name.text = searchResult[indexPath.row].1
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchResult[indexPath.row].0 != .site {
            let desVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchAQIControllerID") as! SearchAQIController
            desVC.id = searchResult[indexPath.row].2
            desVC.searchType = searchResult[indexPath.row].0
            desVC.naviInfo = ("", searchResult[indexPath.row].1)
            self.navigationController?.pushViewController(desVC, animated: true)
        }else {
            if Cache.isAdd {
                self.navigationController?.dismiss(animated: true, completion: nil)
                Cache.setCollectedInfos(element: (searchResult[indexPath.row].0, searchResult[indexPath.row].2))
                Cache.isAdd = false
            } else {
                // 详情页跳转
                let detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewControllerID") as! DetailViewController
                detailViewController.getDetailData(type: searchResult[indexPath.row].0, code: searchResult[indexPath.row].2)
                detailViewController.navigationItem.title = searchResult[indexPath.row].1
                self.navigationController?.pushViewController(detailViewController, animated: true)
            }
        }
    }
}

extension SearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchResult = provinceData
        }else{
            self.searchResult = []
            if searchText.containChinese() {
                for index in searchData {
                    if index.1.range(of: searchText) != nil {
                        self.searchResult.append(index)
                    }
                }
            }else{
                for index in searchField {
                    if index.key.range(of: searchText) != nil {
                        self.searchResult += index.value
                    }
                }
            }
            
        }
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
