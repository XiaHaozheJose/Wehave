//
//  UIBarbuttonItem+Extension.swift
//  Wehave
//
//  Created by 浩哲 夏 on 2018/2/17.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    
    convenience init(imageName:String,hightImageName:String?,size:CGSize = CGSize.zero) {
        let button = UIButton.init()
        button.setImage(UIImage.init(named: imageName), for: .normal)
        if hightImageName != nil {
            button.setImage(UIImage.init(named: hightImageName!), for: .highlighted)
        }
        if size == CGSize.zero {
            button.sizeToFit()
        }else{
            button.frame = CGRect.init(origin:CGPoint.zero, size: size)
        }
        let backGroundView = UIView.init(frame: button.frame)
        backGroundView.addSubview(button)
        
        
        self.init(customView:backGroundView)
    }
    
}
