//
//  MeasureView.swift
//  airmaster
//
//  Created by Howie on 2017/5/24.
//  Copyright © 2017年 Howie. All rights reserved.
//

import UIKit

@IBDesignable
class MeasureView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var iconBackView: UIView!
    @IBOutlet weak var measureItem: UILabel!
    @IBOutlet weak var measureText: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialFromXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialFromXib()
    }
    
    func initialFromXib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "MeasureView", bundle: bundle)
        contentView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        contentView.frame = bounds
        addSubview(contentView)
    }

}
