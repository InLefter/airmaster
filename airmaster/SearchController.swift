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
    
    var provinceData = Array<(String, String)>()
    var searchData = Array<(InfoType, String, String)>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        
        provinceData = DataModel.provinceData()
        searchData = DataModel.searchData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SendPid" {
            let desVC = segue.destination as! SearchAQIController
            let indexPath = tableView.indexPathForSelectedRow
            desVC.id = provinceData[(indexPath?.row)!].1
            desVC.searchType = .province
            desVC.naviInfo = ("", provinceData[(indexPath?.row)!].0)
            self.title = "搜索"
        }
    }

}

extension SearchController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return provinceData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCellID", for: indexPath) as! SearchCell
        cell.name.text = provinceData[indexPath.row].0
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
}

extension SearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        <#code#>
    }
}
