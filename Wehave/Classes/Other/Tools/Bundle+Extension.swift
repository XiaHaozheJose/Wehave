//
//  Bundle+Extension.swift
//
//  Created by 浩哲 夏 on 2017/9/13.
//  Copyright © 2017年 浩哲 夏. All rights reserved.
//

import Foundation


extension Bundle{
    var namespace: String{
        return infoDictionary?["CFBundleName"] as? String ?? ""
    } 
}
