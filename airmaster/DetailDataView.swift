//
//  DetailDataView.swift
//  airmaster
//
//  Created by Howie on 2017/4/28.
//  Copyright © 2017年 Howie. All rights reserved.
//

import UIKit
import Foundation

@IBDesignable
class DetailDataView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet var name: UILabel!
    @IBOutlet var quality: UILabel!
    @IBOutlet var value: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialFromXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialFromXib()
    }
    
    func drawColorRect(color: CGColor) {
        let layer = CAShapeLayer()
        layer.frame = CGRect(x: quality.frame.minX, y: quality.frame.maxY + 10, width: value.frame.maxX - quality.frame.minX + 9, height: 2)
        layer.backgroundColor = color
        self.contentView.layer.addSublayer(layer)
    }
    
    func initialFromXib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "DetailDataView", bundle: bundle)
        contentView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        contentView.frame = bounds
        addSubview(contentView)
    }
    
}
