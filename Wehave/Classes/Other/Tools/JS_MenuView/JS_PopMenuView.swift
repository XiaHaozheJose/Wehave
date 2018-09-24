//
//  JS_PopMenuView.swift
//  Wehave
//
//  Created by JS_Coder on 2018/6/7.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit

protocol JSPopMenuItemClickDelegate: NSObjectProtocol {
    func popMenuItemClick(tag:Int)
}


class JS_PopMenuView: UIView {

    
    var delegate: JSPopMenuItemClickDelegate?
    /// MARK - frame为弹出popView一个cell的frame
    init(frame: CGRect, imageNameArr:[String], titleArr:[String]) {
        super.init(frame: UIScreen.main.bounds)
        //background full screen
        self.frame = kScreenBounds
        self.backgroundColor = .clear
        
        //corner
        let small_w:CGFloat = 10.0
        let small_h:CGFloat = 6.0
        let small_y = frame.origin.y - small_h
        
        var ww:CGFloat
        if UIScreen.main.bounds.size.width == 414.0 {//iphone plus
            ww = 15.0
        }else {
            ww = 12.0
        }
        
        let small_x = UIScreen.main.bounds.size.width - 8 - ww - small_w
        var small_rect = CGRect.init()
        small_rect.origin.x = small_x
        small_rect.origin.y = small_y
        small_rect.size.width = small_w
        small_rect.size.height = small_h
        let smallImageView = UIImageView.init(frame: small_rect)
        smallImageView.image = UIImage.init(named: "popTop")
        self.addSubview(smallImageView)
        
        let popCtrl_w = frame.size.width
        let popCtrl_h = frame.size.height
        let popCtrl_x = frame.origin.x
        
        for index in 0..<imageNameArr.count {
            let popCtrl_y = frame.origin.y + CGFloat(index) * popCtrl_h
            
            var popCtrl_rect = CGRect.init()
            popCtrl_rect.origin.x = popCtrl_x
            popCtrl_rect.origin.y = popCtrl_y
            popCtrl_rect.size.width = popCtrl_w
            popCtrl_rect.size.height = popCtrl_h
            
            var isLastCell:Bool = false
            ///最后一个cell隐藏底部line
            if index == imageNameArr.count-1 {
                isLastCell = true
            }
            
            let popCtrl = JS_PopControl.init(frame: popCtrl_rect, imageName: imageNameArr[index], title: titleArr[index], hiddenLine:isLastCell)
            
            popCtrl.tag = index
            popCtrl.addTarget(self, action: #selector(popCtrlClick), for: .touchUpInside)
            self.addSubview(popCtrl)
        }
        
        UIApplication.shared.keyWindow?.addSubview(self)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
        }) { (view) in
            self.removeFromSuperview()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
        }) { (view) in
            self.removeFromSuperview()
        }
    }
    
    @objc func popCtrlClick(popCtrl:JS_PopControl) {
        guard delegate == nil else {
            delegate?.popMenuItemClick(tag: popCtrl.tag)
            UIView.animate(withDuration: 0.25, animations: {
                self.alpha = 0
            }, completion: { (view) in
                self.removeFromSuperview()
            })
            return
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
