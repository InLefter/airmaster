//
//  CAnnotationView.swift
//  airmaster
//
//  Created by Howie on 2017/5/16.
//  Copyright © 2017年 Howie. All rights reserved.
//

import UIKit
import MapKit

class CAnnotationView: MKAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        self.frame.size.width = 10
        self.frame.size.height = 10
        self.layer.cornerRadius = 5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
