//
//  JS_CircleLabel.swift
//  JS_Calendar
//
//  Created by JS_Coder on 2018/4/1.
//  Copyright © 2018年 JS_Coder. All rights reserved.
//

import UIKit
class JS_CircleLabel: UILabel {
    var isSelected: Bool = false {
        didSet{
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        if isSelected {
            CALENDAR_SELECT_BACKGROUNDCOLOR.setFill()
            let bezierPath = UIBezierPath()
            let center = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
            bezierPath.addArc(withCenter: center , radius: self.frame.size.height / 2, startAngle: 0, endAngle: 180, clockwise: true)
            bezierPath.fill()
        }
        super.drawText(in: rect)
    }
    
    
}
