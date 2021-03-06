//
//  MapViewController.swift
//  airmaster
//
//  Created by Howie on 2017/5/10.
//  Copyright © 2017年 Howie. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

// 大头针显示等级
enum ZoomLevel {
    case circle
    case value
    case circleWithValue
}

class MapViewController: UIViewController, PollutionPickerProtocol {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var pickerView = PollutionPickerController()
    
    @IBOutlet weak var localeUser: UIView!
    
    @IBOutlet weak var pollution: UIButton!
    @IBAction func changePollution(_ sender: Any) {
        pickerView.modalPresentationStyle = .popover
        pickerView.popoverPresentationController?.delegate = self
        pickerView.popoverPresentationController?.sourceRect = pollution.bounds
        pickerView.popoverPresentationController?.sourceView = pollution
        pickerView.preferredContentSize = CGSize(width: 200, height: 200)
        pickerView.popoverPresentationController?.permittedArrowDirections = .down
        pickerView.delegate = self
        self.present(pickerView, animated: true, completion: nil)
    }
    
    @IBAction func shareApp(_ sender: Any) {
        let shareVC = UIActivityViewController(activityItems: SHARE_ITEM, applicationActivities: nil)
        self.present(shareVC, animated: true, completion: nil)
    }
    
    var currentPollution: Pollution!
    
    var level: ZoomLevel!
    
    var pollutionInfos = Array<VAnnotation>()
    
    var beforeRegion: MKCoordinateRegion!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        let gr = UITapGestureRecognizer(target: self, action: #selector(locale))
        gr.numberOfTapsRequired = 1
        localeUser.isUserInteractionEnabled = true
        localeUser.addGestureRecognizer(gr)
        
        currentPollution = .aqi
        pollution.setTitle(Pollution.aqi.rawValue, for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func selectPollution(type: Pollution) {
        self.currentPollution = type
        pollution.setTitle(type.rawValue, for: .normal)
        
        for annotatin in mapView.annotations {
            if let ann = annotatin as? VAnnotation {
                if level == .circle || (level == .circleWithValue && ann.type == .site) {
                    let v = mapView.view(for: ann) as! CAnnotationView
                    v.backgroundColor = UIColor(cgColor: (ann.pollution[currentPollution]?.color)!)
                } else if level == .value || (level == .circleWithValue && ann.type == .city) {
                    let v = mapView.view(for: ann) as! VAnnotationView
                    v.redrawView(value: ann.pollution[currentPollution]?.value, color: (ann.pollution[currentPollution]?.color)!)
                }
            }
        }
    }

    func locale() {
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let tmpLevel = level
        switch mapView.region.span.latitudeDelta {
        case 0..<0.8:
            level = .value
        case 0.8..<8.5:
            level = .circleWithValue
        case 8.5..<15:
            level = .value
        default:
            level = .circle
        }
        
        Request.getMapInfo(region: mapView.region, complete: { annotations in
            // 移除当前区域外的大头针
            if tmpLevel == self.level {
                for an in mapView.annotations{
                    if let annotation = an as? VAnnotation {
                        if !(mapView.region.isComprise(point: annotation.coordinate)) {
                            mapView.removeAnnotation(an)
                        }
                    }
                }
                for i in 0..<annotations.count {
                    if !(self.beforeRegion.isComprise(point: annotations[i].coordinate)) {
                        mapView.addAnnotation(annotations[i])
                    }
                }
                
            } else {
                self.mapView.removeAnnotations(mapView.annotations)
                self.mapView.addAnnotations(annotations)
            }
            self.pollutionInfos = annotations
            self.beforeRegion = mapView.region
        })
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        if annotation.isKind(of: VAnnotation.self) {
            let ann = annotation as! VAnnotation
            if level == .circle || (level == .circleWithValue && ann.type == .site) {
                var aView = mapView.dequeueReusableAnnotationView(withIdentifier: "CAnnotationView") as? CAnnotationView
                if aView == nil {
                    aView = CAnnotationView(annotation: annotation, reuseIdentifier: "CAnnotationView")
                }
                aView?.canShowCallout = true
                aView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                aView?.backgroundColor = UIColor(cgColor: (ann.pollution[currentPollution]?.color)!)
                aView?.annotation = annotation
                return aView
            } else if level == .value || (level == .circleWithValue && ann.type == .city) {
                var aView = mapView.dequeueReusableAnnotationView(withIdentifier: "VAnnotationView") as? VAnnotationView
                if aView == nil {
                    aView = VAnnotationView(annotation: annotation, reuseIdentifier: "VAnnotationView")
                }
                aView?.canShowCallout = true
                aView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                if let po = ann.pollution[currentPollution] {
                    aView?.redrawView(value: po.value, color: po.color)
                } else {
                    aView?.redrawView(value: "-", color: UIColor.lightGray.cgColor)
                }
                aView?.annotation = annotation
                return aView
            }
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // 详情页跳转
        let detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewControllerID") as! DetailViewController
        let va = view.annotation as! VAnnotation
        detailViewController.detailData = va.info
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}


extension MapViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
