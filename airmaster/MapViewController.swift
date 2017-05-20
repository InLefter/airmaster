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
    
    var pollutionInfos = (cities: Array<VAnnotation>(), sites: Array<VAnnotation>())
    
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
    
    func transToAnnotion(array: Array<Info>, type: InfoType) {
        if type == .city {
            pollutionInfos.cities.removeAll()
            for item in array {
                let city = VAnnotation(coordinate: item.coordinate, type: .city, info: item)
                pollutionInfos.cities.append(city)
            }
        } else if type == .site {
            pollutionInfos.sites.removeAll()
            for item in array {
                let site = VAnnotation(coordinate: item.coordinate, type: .site, info: item)
                pollutionInfos.cities.append(site)
            }
        }
        
    }
    
    func test() {
//        let detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewControllerID") as! DetailViewController
//       
//        detailViewController.detailData = info
//        self.navigationController?.pushViewController(detailViewController, animated: true)
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
        
        Request.getMapInfo(region: mapView.region, complete: { cities, sites in
            
            if tmpLevel == self.level {
                var repeated = Array<VAnnotation>()
                var unrepeated = Array<VAnnotation>()
                let cities_sets = Set(cities)
                let sites_sets = Set(sites)
                let city = Set(self.pollutionInfos.cities)
                let site = Set(self.pollutionInfos.sites)
            }
            self.mapView.removeAnnotations(self.pollutionInfos.cities)
            self.mapView.removeAnnotations(self.pollutionInfos.sites)
            
            self.transToAnnotion(array: cities, type: .city)
            self.transToAnnotion(array: sites, type: .site)
            
            self.mapView.addAnnotations(self.pollutionInfos.cities)
            self.mapView.addAnnotations(self.pollutionInfos.sites)
            
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
                let bt = UIButton(type: .detailDisclosure)
                bt.addTarget(nil, action: #selector(test), for: .touchUpInside)
                aView?.rightCalloutAccessoryView = bt
                aView?.backgroundColor = UIColor(cgColor: (ann.pollution[currentPollution]?.color)!)
                aView?.annotation = annotation
                return aView
            } else if level == .value || (level == .circleWithValue && ann.type == .city) {
                var aView = mapView.dequeueReusableAnnotationView(withIdentifier: "VAnnotationView") as? VAnnotationView
                if aView == nil {
                    aView = VAnnotationView(annotation: annotation, reuseIdentifier: "VAnnotationView")
                }
                aView?.canShowCallout = true
                let bt = UIButton(type: .detailDisclosure)
                bt.addTarget(nil, action: #selector(test), for: .touchUpInside)
                aView?.rightCalloutAccessoryView = bt
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
}
