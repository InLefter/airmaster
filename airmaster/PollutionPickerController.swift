//
//  PollutionPickerController.swift
//  airmaster
//
//  Created by Howie on 2017/4/30.
//  Copyright © 2017年 Howie. All rights reserved.
//

import UIKit

let PollutionType = [Pollution.aqi,Pollution.pm2_5,Pollution.pm10,Pollution.co,Pollution.so2,Pollution.no2]


protocol PollutionPickerProtocol {
    func selectPollution(type: Pollution)
}

class PollutionPickerController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var pickerView: UIPickerView!
    
    var delegate: PollutionPickerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.preferredContentSize = CGSize(width: 200, height: 200)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*--------------------*/
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 6
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return PollutionType[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.selectPollution(type: PollutionType[row])
        pickerView.selectRow(row, inComponent: 0, animated: true)
    }

}
