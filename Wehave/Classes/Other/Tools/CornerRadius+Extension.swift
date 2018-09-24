//
//  CornerRadius+Extension.swift
//  Wehave
//
//  Created by JS_Coder on 2018/4/5.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit

extension UIView{
    func addCorner(roudingCorners: UIRectCorner, cornerSize: CGSize){
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: roudingCorners, cornerRadii: cornerSize)
        let cornerLayer = CAShapeLayer()
        cornerLayer.frame = bounds
        cornerLayer.path = path.cgPath
        layer.mask = cornerLayer
    }
}
