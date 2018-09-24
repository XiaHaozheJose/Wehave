//
//  WHBottomIntroduceView.swift
//  Wehave
//
//  Created by JS_Coder on 2018/3/18.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit

class WHBottomIntroduceView: UIView {

    class func introduceView()->WHBottomIntroduceView{
        let nib = UINib(nibName: "WHBottomIntroduceView", bundle: nil)
        let introduce = nib.instantiate(withOwner: nil, options: nil)[0] as! WHBottomIntroduceView
        return introduce
    }
}
