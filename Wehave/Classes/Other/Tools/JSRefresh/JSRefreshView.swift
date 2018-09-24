//
//  JSRefreshView.swift
//  Wehave
//
//  Created by JS_Coder on 2018/3/4.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit

class JSRefreshView: UIView {
    
    var refreshStatus: JSRefreshState = .Normal{
        didSet{
            switch refreshStatus {
            case .Normal:
                tipLabel.text = "Drop down ..."
                tipIcon.isHidden = false
                indicator.stopAnimating()
                UIView.animate(withDuration: 0.25){
                    self.tipIcon.transform = CGAffineTransform.identity
                }
            case .Pulling:
                tipLabel.text = "Release refresh ..."
                UIView.animate(withDuration: 0.25){
                    // 就近原则 怎么去怎么回 -0.001 
                    self.tipIcon.transform = CGAffineTransform(rotationAngle: .pi - 0.001)
                }
            case .Refreshing:
                tipLabel.text = "Being loaded ..."
                tipIcon.isHidden = true
                indicator.startAnimating()
            }
        }
    }
    // Refresh Icon
    @IBOutlet weak var tipIcon: UIImageView!
    // Refresh Label
    @IBOutlet weak var tipLabel: UILabel!
    // Indicator Refreshing
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    class func refreshView()->JSRefreshView{
        let nib = UINib(nibName: "JSRefreshView", bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil)[0] as! JSRefreshView
    }

}
