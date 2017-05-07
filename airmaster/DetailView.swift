//
//  DetailView.swift
//  airmaster
//
//  Created by Howie on 2017/5/6.
//  Copyright © 2017年 Howie. All rights reserved.
//

import UIKit
import Foundation

@IBDesignable
class DetailView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var value: UILabel!
    
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
        layer.frame = CGRect(x: type.frame.minX, y: self.bounds.maxY - 4, width: value.frame.maxX - type.frame.minX + 2, height: 2)
        layer.backgroundColor = color
        self.contentView.layer.addSublayer(layer)
    }
    
    func initialFromXib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "DetailView", bundle: bundle)
        contentView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        contentView.frame = bounds
        addSubview(contentView)
    }

}
