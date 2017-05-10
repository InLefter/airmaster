//
//  RankController.swift
//  airmaster
//
//  Created by Howie on 2017/5/5.
//  Copyright © 2017年 Howie. All rights reserved.
//

import UIKit

class RankController: UIViewController, PollutionPickerProtocol {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var typeSegment: UISegmentedControl!
    
    var pickerView = PollutionPickerController()
    
    var ranksArray = Array<RankData>()
    var sequence: Bool!
    var pickType: Pollution!
    
    @IBAction func share(_ sender: Any) {
        
    }
    
    @IBOutlet weak var typeBt: UIButton!
    
    @IBAction func changeKind(_ sender: Any) {
        pickerView.modalPresentationStyle = .popover
        pickerView.popoverPresentationController?.delegate = self
        pickerView.popoverPresentationController?.sourceRect = typeBt.bounds
        pickerView.popoverPresentationController?.sourceView = typeBt
        pickerView.preferredContentSize = CGSize(width: 200, height: 200)
        pickerView.delegate = self
        self.present(pickerView, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.typeBt.backgroundColor = UIColor(dex: 0xdfdfdf)

        self.tableView.estimatedRowHeight = 55
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.automaticallyAdjustsScrollViewInsets = false
        
        typeSegment.selectedSegmentIndex = 0
        sequence = true
        typeSegment.addTarget(self, action: #selector(clickSegment), for: .valueChanged)
        
        pickType = .aqi
        selectPollution(type: pickType)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func clickSegment(seg: UISegmentedControl) {
        let index = seg.selectedSegmentIndex
        switch index {
        case 0:
            if !sequence {
                sequence = true
                selectPollution(type: pickType)
            }
            break
        default:
            if sequence {
                sequence = false
                selectPollution(type: pickType)
            }
            break
        }
    }
    
    func selectPollution(type: Pollution) {
        pickType = type
        self.typeBt.setTitle(type.rawValue, for: .normal)
        
        Request.getRank(type: type, sequence: sequence, complete: { (isSuccess, result) in
            if isSuccess {
                self.ranksArray = result
                self.tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                self.tableView.reloadData()
            }
        })
    }

}

extension RankController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ranksArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //
        let rankCell = tableView.dequeueReusableCell(withIdentifier: "RankCellID", for: indexPath) as! RankCell
        rankCell.name.text = ranksArray[indexPath.row].name
        rankCell.rank.text = ranksArray[indexPath.row].range
        rankCell.province.text = ranksArray[indexPath.row].province
        rankCell.value.text = ranksArray[indexPath.row].value
        rankCell.value.layer.backgroundColor = ranksArray[indexPath.row].valueColor
        
        rankCell.selectionStyle = .none
        return rankCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewControllerID") as! DetailViewController
        detailViewController.getDetailData(type: .city, code: ranksArray[indexPath.row].code, name: ranksArray[indexPath.row].name)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension RankController: UIPopoverPresentationControllerDelegate {
    /// 一定要实现此方法(由于当时忘记了这个，导致popover出的PickerView大小不对，检查了半天)
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
