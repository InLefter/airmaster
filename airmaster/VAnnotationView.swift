//
//  VAnnotationView.swift
//  airmaster
//
//  Created by Howie on 2017/5/14.
//  Copyright © 2017年 Howie. All rights reserved.
//

import UIKit
import MapKit

class VAnnotationView: MKAnnotationView {

    
    var cLayer = CAShapeLayer()
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
    
    func redrawView(value: String?, color: CGColor) {
        let valueLabel = UILabel()
        valueLabel.frame = CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: 0, height: 0))
        valueLabel.textColor.withAlphaComponent(0.9)
        valueLabel.textColor = UIColor.white
        valueLabel.numberOfLines = 0
        valueLabel.textAlignment = .center
        valueLabel.adjustsFontSizeToFitWidth = true
        valueLabel.font = UIFont.systemFont(ofSize: 12)
        
        let rect = (value?.rectWithConstrainedHeight(height: 12, font: valueLabel.font))!
        valueLabel.frame = rect
        valueLabel.center = CGPoint(x: rect.midX + 4, y: 10)
        valueLabel.text = value!
        
        self.frame.size = CGSize(width: rect.width + 8, height: 24)
        
        if let layer = self.layer.sublayers {
            if !layer.isEmpty {
                self.layer.sublayers?.last?.removeFromSuperlayer()
            }
        }
        
        let pathRef = CGMutablePath()
        
        let bounds = self.bounds
        let maxY = bounds.maxY - 5
        
        pathRef.move(to: CGPoint(x: bounds.minX, y: bounds.midY))
        pathRef.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.minY), tangent2End: CGPoint(x: bounds.midX, y: bounds.minY), radius: CGFloat(3))
        pathRef.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.minY), tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY), radius: CGFloat(3))
        pathRef.addArc(tangent1End: CGPoint(x: bounds.maxX, y: maxY), tangent2End: CGPoint(x: bounds.midX, y: maxY), radius: CGFloat(3))
        pathRef.addLine(to: CGPoint(x: bounds.midX + 5, y: maxY))
        pathRef.addLine(to: CGPoint(x: bounds.midX, y: bounds.maxY))
        pathRef.addLine(to: CGPoint(x: bounds.midX - 5, y: maxY))
        pathRef.addArc(tangent1End: CGPoint(x: bounds.minX, y: maxY), tangent2End: CGPoint(x: bounds.minX, y: bounds.midY - 5), radius: CGFloat(3))
        
        self.backgroundColor = UIColor.clear
        cLayer.path = pathRef
        cLayer.fillColor = color
        self.layer.insertSublayer(cLayer, at: 0)
        
        self.addSubview(valueLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
