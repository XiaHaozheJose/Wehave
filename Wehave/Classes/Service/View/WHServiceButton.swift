//
//  WHServiceButton.swift
//  Wehave
//
//  Created by JS_Coder on 2018/3/5.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit

class WHServiceButton: UIControl {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    var clsName: String?
    
    class func serviceButton(image: UIImage, title: String)->WHServiceButton{
        /*
         ##Important XIB Delete Autoresizing 
         */
        let btn = UINib(nibName: "WHServiceButton", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! WHServiceButton
        btn.imageView.image = image
        btn.titleLabel.text = title
        return btn
    }

}
