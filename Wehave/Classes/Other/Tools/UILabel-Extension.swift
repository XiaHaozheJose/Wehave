//
//  UILabel-Extension.swift
//  Wehave
//
//  Created by JS_Coder on 2018/4/6.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit
extension UILabel{
    func sizeWithText(maxSize: CGSize) -> CGSize {
        let nilRect = CGRect(x: 0, y: 0, width: 0, height: 0)
        guard let _ = self.text else {return nilRect.size}
        let attributes = [NSAttributedStringKey.font: self.font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect:CGRect = self.text!.boundingRect(with: CGSize(width: maxSize.width, height: maxSize.height), options: option, attributes: attributes, context: nil)
        return rect.size;
    }
}

