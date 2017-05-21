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

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
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

        currentPollution = .aqi
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
