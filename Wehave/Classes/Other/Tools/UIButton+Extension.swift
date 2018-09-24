//
//  UIButton+Extension.swift
//  Wehave
//
//  Created by 浩哲 夏 on 2018/2/16.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit

extension UIButton{
    
    convenience init(imageName : UIImage , highImageName :UIImage , title : String , bgImageName : UIImage,bgHighImage : UIImage) {
        self.init()
        setImage(imageName, for: .normal)
        setTitle(title, for: .normal)
        setBackgroundImage(bgImageName, for: .normal)
        setImage(highImageName, for: .selected)
        setImage(bgHighImage, for: .selected)
        sizeToFit()
    }
    
    
    
}


