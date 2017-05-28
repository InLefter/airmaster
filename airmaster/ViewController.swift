//
//  ViewController.swift
//  airmaster
//
//  Created by Howie on 2017/4/25.
//  Copyright © 2017年 Howie. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func shareApp(_ sender: Any) {
        let shareVC = UIActivityViewController(activityItems: SHARE_ITEM, applicationActivities: nil)
        self.present(shareVC, animated: true, completion: nil)
    }
    
    lazy var locationMgr: CLLocationManager = {
        let locationMgr = CLLocationManager()
        locationMgr.delegate = self
        
        locationMgr.requestWhenInUseAuthorization()
        
        return locationMgr
    }()
    
    /// nearBy:本地信息 collect:收藏地点信息
    var infos = (nearBy: Array<Info>(), collect: Array<Info>())

    let locationIcon = UIImage(named: "location_icon")
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.infos.collect.count == Cache.collection.count - 1 {
            getDetailInfo(collection: Cache.collection.last!, isInsert: true)
        }
    }
    
    var flag = true
    
    var location: CLLocation! {
        didSet{
            if flag {
                var requestBody = [String:String]()
                requestBody["lat"] = String(describing: location.coordinate.latitude)
                requestBody["lon"] = String(describing: location.coordinate.longitude)
                Request.getNearByInfo(parameters: requestBody, complete: { (success, data) in
                    if success {
                        self.infos.nearBy = data
                        self.dataToInfo()
                    }
                })
                flag = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "空气管家"
        self.tabBarController?.tabBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        let nib = UINib(nibName: "AirDetailCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "AirDetailCellID")
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.automaticallyAdjustsScrollViewInsets = false
        
        locationMgr.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 归档化数据 -> Info
    func dataToInfo() {
        Cache.getCollectedInfos()
        
        if Cache.collection.count == 0 {
            tableView.reloadData()
        } else {
            for item in Cache.collection {
                getDetailInfo(collection: item, isInsert: false)
            }
        }
        
    }
    
    func getDetailInfo(collection: (InfoType, String), isInsert: Bool) {
        Request.getPublishData(type: collection.0, code: collection.1, complete: { (isSuccess, latest) in
            if isSuccess {
                self.infos.collect.append(latest)
                if isInsert {
                    let indexPath = IndexPath(row: Cache.collection.count - 1, section: 1)
                    self.tableView.insertRows(at: [indexPath], with: .middle)
                } else {
                    if self.infos.collect.count == Cache.collection.count {
                        self.tableView.reloadData()
                    }
                }
            } else {
                //
            }
        })
    }
    
    // 增加收藏城市/站点
    func showSearchVC() {
        Cache.isAdd = true
        let searchNavigationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchNavigationVCID") as! UINavigationController
        self.present(searchNavigationVC, animated: true, completion: nil)
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    /// section count
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2;
    }
    
    /// rows of section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return infos.nearBy.count
        }else {
            return infos.collect.count
        }
    }
    
    /// 不同的section，绘制不同的cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AirDetailCellID", for: indexPath) as! AirDetailCell
        
        var datas = Array<Info>()
        if indexPath.section == 0 {
            datas = infos.nearBy
            cell.positionIcon.isHidden = false
            cell.positionIcon.image = locationIcon
            if indexPath.row == 0 {
//                cell.measureView.icon
            }
        } else {
            datas = infos.collect
            cell.positionIcon.isHidden = true
        }
        
        cell.cityName.text = datas[indexPath.row].name
        guard let aqi = datas[indexPath.row].aqi else {
            return cell
        }
        cell.AQI.text = String(describing: aqi)
        cell.airQuality.text = datas[indexPath.row].quality
        
        // 取污染物等级指数排行前三位(逆序)
        for i in 0...2 {
            cell.detailViews[i].type.text = datas[indexPath.row].pollutionData[i].name.rawValue
            cell.detailViews[i].value.text = String(datas[indexPath.row].pollutionData[i].value)
            cell.detailViews[i].drawColorRect(color: PollutionColor[datas[indexPath.row].pollutionData[i].quality]!)
        }
        
        cell.time.text = datas[indexPath.row].time?.formatStamp()

        return cell
    }
    
    /// 选择cell操作
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewControllerID") as! DetailViewController
        var datas = Array<Info>()
        if indexPath.section == 0 {
            datas = infos.nearBy
        }else {
            datas = infos.collect
        }
        detailViewController.detailData = datas[indexPath.row]
        self.navigationController?.pushViewController(detailViewController, animated: true)
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

    // section heder设置
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        let label = UILabel()
        label.textColor = UIColor.gray
        if section == 0 {
            label.text = "附近"
        }else{
            label.text = "收藏"
            let add = UIButton()
            add.setImage(UIImage(named: "add_icon"), for: .normal)
            add.sizeToFit()
            add.center = CGPoint(x: UIScreen.main.bounds.width - 30, y: 30)
            add.addTarget(self, action: #selector(showSearchVC), for: .touchUpInside)
            view.addSubview(add)
        }
        label.sizeToFit()
        label.font = UIFont(name: "System-Light", size: 14)
        label.center = CGPoint(x: 40, y: 30)
        view.addSubview(label)
        return view
    }
    
    // 左滑删除
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Cache.removeOne(id: self.infos.collect[indexPath.row].code!)
            infos.collect.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}


extension ViewController: CLLocationManagerDelegate{

    // 更新地理位置
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else {
            return
        }
        location = loc
        manager.stopUpdatingLocation()
    }
    
    // 地理位置授权检查
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
