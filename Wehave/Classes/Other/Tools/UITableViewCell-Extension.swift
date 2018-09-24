//
//  UITableViewCell-Extension.swift
//  Wehave
//
//  Created by JS_Coder on 2018/5/1.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import Foundation


// MARK: - Get Current TopView in 
extension UITableViewCell{
    func getCurrentViewController()->UIViewController?{
        let rootView = UIApplication.shared.keyWindow?.rootViewController
        if rootView is UINavigationController {
            let navigation = rootView as! UINavigationController
            return navigation.topViewController
        }else if  rootView is UITabBarController{
            let tabController = rootView as! UITabBarController
            let navi = tabController.childViewControllers.first as! UINavigationController
            return navi.topViewController
        }
        return nil
    }
}
