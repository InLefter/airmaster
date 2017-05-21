//
//  Func.swift
//  airmaster
//
//  Created by Howie on 2017/4/28.
//  Copyright © 2017年 Howie. All rights reserved.
//
import UIKit
import Foundation
import MapKit

let startP = degreeToRadius(ang: -210)

let SCREN_WIDTH = UIScreen.main.bounds.width

func degreeToRadius(ang: Double) -> CGFloat{
    return CGFloat(Double.pi * (ang) / 180.0)
}
