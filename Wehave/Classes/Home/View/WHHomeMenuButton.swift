//
//  WHHomeMenuButton.swift
//  Wehave
//
//  Created by JS_Coder on 2018/6/26.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit

class WHHomeMenuButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if let titleLabel = self.titleLabel, let imageView = self.imageView {
            // Title
            self.titleEdgeInsets = UIEdgeInsetsMake(imageView.frame.size.height + 5, -imageView.bounds.size.width, 0,0);
            // ImageView
            self.imageEdgeInsets = UIEdgeInsetsMake(0, titleLabel.frame.size.width / 2, titleLabel.frame.size.height + 5, -(titleLabel.frame.size.width / 2));
        }
    }
    
    
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
