//
//  LoadNibView.swift
//  Wehave
//
//  Created by JS_Coder on 2018/5/30.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

protocol LoadNibView {
}

extension LoadNibView where Self : UIView{
    static func loadFromNib(_ nibName: String? = nil) -> Self {
        let loadName = nibName == nil ? "\(self)" : nibName!
        return Bundle.main.loadNibNamed(loadName, owner: nil, options: nil)?.first as! Self
    }
}
