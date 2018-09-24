//
//  WHTabBar.swift
//  Wehave
//
//  Created by 浩哲 夏 on 2018/2/16.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit
let serviceNotification = NSNotification.Name(rawValue:"publishModal")
let repeatClickTabBarButton = NSNotification.Name(rawValue:"repeatClickTabBarButton")
class WHTabBar: UITabBar {

    var previousButton : UIControl?
    fileprivate var clickClousure: (()->())?
    lazy var actionButton: UIButton = {
        let actionButton = UIButton()
        actionButton.setImage(#imageLiteral(resourceName: "tabBar_publish_icon"), for: .normal)
        actionButton.setImage(#imageLiteral(resourceName: "tabBar_publish_click_icon"), for: .highlighted)
        actionButton.addTarget(self, action: #selector(ClickActionButton), for: .touchUpInside)
        actionButton.sizeToFit()
        self.addSubview(actionButton)
        return actionButton
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let count = self.items?.count else {
            return
        }
        let widthItem : CGFloat = self.frame.width / (CGFloat)(count + 1)
        let heightItem : CGFloat = self.frame.height
        var itemX : CGFloat?
        
        var i : Int = 0
        
        for tabBar in self.subviews {
            if tabBar.isKind(of:NSClassFromString("UITabBarButton")!){
                if i == 2 {
                    i += 1
                }
                itemX = (CGFloat)(i) * widthItem
                tabBar.frame = CGRect.init(x:itemX!, y: 0, width: widthItem, height: heightItem)
                (tabBar as! UIControl).addTarget(self, action: #selector(ClickButton(tabBarButton:)), for: .touchUpInside)
                i+=1;
            }
//            actionButton.frame.size = CGSize(width: widthItem, height: heightItem)
            actionButton.center = CGPoint.init(x: self.frame.width*0.5, y: self.frame.height*0.25)
            
        }
    }
}


// MARK: - 监听TabBar按钮点击
extension WHTabBar{
    @objc fileprivate func ClickButton(tabBarButton : UIControl){
        if previousButton == tabBarButton {
            NotificationCenter.default.post(name: repeatClickTabBarButton, object: nil)
        }
        previousButton = tabBarButton
    }
    
    //publish 按钮点击
    @objc fileprivate func ClickActionButton(){
        NotificationCenter.default.post(name: serviceNotification, object: nil)
    }
}
