//
//  ViewController.swift
//  airmaster
//
//  Created by Howie on 2017/4/25.
//  Copyright © 2017年 Howie. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var locationMgr: CLLocationManager = {
        let locationMgr = CLLocationManager()
        locationMgr.delegate = self
        
        locationMgr.requestWhenInUseAuthorization()
        
        return locationMgr
    }()
    
    var infos = Array<Info>()

    let locationIcon = UIImage(named: "location.png")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "AirDetailCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "AirDetailCellID")
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        getLocationInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getLocationInfo(){
        locationMgr.startUpdatingLocation()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AirDetailCellID", for: indexPath) as! AirDetailCell
        cell.cityName.text = infos[indexPath.row].name
        guard let aqi = infos[indexPath.row].aqi else {
            return cell
        }
        cell.AQI.text = String(describing: aqi)
        cell.positionIcon.image = locationIcon
        cell.airQuality.text = infos[indexPath.row].quality
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
    
    // 重绘cell圆弧形状
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cornerRadius = 6
        cell.backgroundColor = UIColor.clear
        
        let layer = CAShapeLayer()
        let backgroundLayer = CAShapeLayer()
        
        let pathRef = CGMutablePath()
        
        let bounds = cell.bounds.insetBy(dx: 10, dy: 5)
        
        pathRef.move(to: CGPoint(x: bounds.minX, y: bounds.midY))
        pathRef.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.minY), tangent2End: CGPoint(x: bounds.midX, y: bounds.minY), radius: CGFloat(cornerRadius))
        pathRef.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.minY), tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY), radius: CGFloat(cornerRadius))
        pathRef.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.maxY), tangent2End: CGPoint(x: bounds.midX, y: bounds.maxY), radius: CGFloat(cornerRadius))
        pathRef.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.maxY), tangent2End: CGPoint(x: bounds.minX, y: bounds.midY), radius: CGFloat(cornerRadius))
        
        layer.path = pathRef
        backgroundLayer.path = pathRef
        
        layer.fillColor = UIColor.white.cgColor
        
        let view = UIView(frame: bounds)
        view.layer.insertSublayer(layer, at: 0)
        view.backgroundColor = UIColor.clear
        cell.backgroundView = view
        
        let selectedView = UIView(frame: bounds)
        backgroundLayer.fillColor = UIColor.white.cgColor
        selectedView.layer.insertSublayer(backgroundLayer, at: 0)
        selectedView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = selectedView
    }

}


extension ViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else {
            return
        }
        
        manager.stopUpdatingLocation()
        
        var requestBody = [String:String]()
        
        requestBody["lat"] = String(describing: loc.coordinate.latitude)
        requestBody["lon"] = String(describing: loc.coordinate.longitude)
        
        Request.getNearByInfo(parameters: requestBody, complete: { (success, data) in
            if success {
                self.infos = data
                print(data.count)
                self.tableView.reloadData()
            }
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            // 用户未选择
            break
        case .restricted:
            // 限制
            break
        case .denied:
            // 拒绝
            if CLLocationManager.locationServicesEnabled() {
                // 跳转设置权限
                if #available(iOS 9.0, *) {
                    let url = URL(string: UIApplicationOpenSettingsURLString)
                    if UIApplication.shared.canOpenURL(url!) {
                        UIApplication.shared.openURL(url!)
                    }
                }
            }
            break
        default:
            break;
        }
    }
}
