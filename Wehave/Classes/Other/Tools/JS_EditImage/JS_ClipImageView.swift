//
//  JS_ClipImageView.swift
//  Wehave
//
//  Created by JS_Coder on 2018/6/6.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit

enum TouchLocation {
    
    case north
    case south
    case west
    case east
    case center
    case west_north
    case west_south
    case east_north
    case east_south
}

class JS_ClipImageView: UIImageView {
    
    var location:CGPoint?
    var insetRect:CGRect?
    var tempView:UIView?
    var originalFrame:CGRect?
    var timer:Timer = Timer()
    
    var closure:(()->(Bool))?
    var pinchClosure:((CGFloat)->Void)?
    var edageClosure:((UIEdgeInsets)->Void)?
    var orientation:UIImageOrientation = .up
    var clipClosure:(()->Void)?
    var removeImageClosure:(()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.insetRect = frame.insetBy(dx: 10, dy: 10)
        tempView = UIView.init()
        tempView?.isUserInteractionEnabled = false
        tempView?.frame = insetRect!
        originalFrame = frame
        
        let pinch =  UIPinchGestureRecognizer.init(target: self, action: #selector(pinchAction(pinch:)))
        self.addGestureRecognizer(pinch)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func pinchAction(pinch:UIPinchGestureRecognizer)  {
        self.pinchClosure?(pinch.scale)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.insetRect = frame.insetBy(dx: 30, dy: 30)
        tempView?.frame = insetRect!
        self.superview!.addSubview(tempView!)
        let touch = ((touches as NSSet).anyObject() as AnyObject)
        
        let point = touch.location(in:self.superview)
        location = point
        
        self.timer.invalidate()
        self.removeImageClosure?()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        let touch = ((touches as NSSet).anyObject() as AnyObject)
        let point = touch.location(in:self.superview)
        
        let dx = (self.location?.x)! - point.x
        let dy = (self.location?.y)! - point.y
        
        self.location = point
        self.updateRect(point: point, dx: dx, dy: dy)
        insetRect = frame.insetBy(dx: 30, dy: 30)
        tempView?.frame = insetRect!
        
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.clipTimeFire()
    }
    
    func clipTimeFire()  {
        tempView?.removeFromSuperview()
        if self.timer.isValid == true {
            self.timer.invalidate()
        }
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(showWillClipArea), userInfo: nil, repeats: false)
    }
    
    @objc func showWillClipArea() {
        
        self.clipClosure?()
        
    }
    
    //       判断点击9大区域图
    //                   |              |
    //       west_north  |     north    | east_north
    //         __________A1_____________A2__________
    //                   |              |
    //                   |              |
    //          west     |     center   | east
    //                   |              |
    //        ___________A3_____________A4_________
    //        west_south |     south    | east_south
    //                   |              |
    func touchLocation(touch:CGPoint,insetFrame:CGRect) -> TouchLocation  {
        
        let inset = insetFrame
        
        let A1:(x:CGFloat,y:CGFloat) = (inset.origin.x,inset.origin.y)
        let A2:(x:CGFloat,y:CGFloat) = (inset.origin.x + inset.size.width,inset.origin.y)
        let A3:(x:CGFloat,y:CGFloat) = (inset.origin.x,inset.origin.y + inset.size.height)
        let A4:(x:CGFloat,y:CGFloat) = (inset.origin.x + inset.size.width,inset.origin.y + inset.size.height)
        
        
        if inset.contains(touch){
            return .center
        }else if touch.x < A1.x && touch.y < A1.y {
            return .west_north
        }else if touch.x < A1.x && touch.y > A3.y{
            return .west_south
        }else if touch.x > A2.x && touch.y < A2.y {
            return .east_north
        }else if touch.x > A4.x && touch.y > A4.y {
            return .east_south
        }else if touch.x > A2.x && touch.y > A2.y && touch.y < A4.y {
            return .east
        }else if touch.x < A1.x && touch.y > A1.y && touch.y < A3.y {
            return .west
        }else if touch.x > A1.x && touch.x < A2.x && touch.y < A1.y {
            return .north
        }else if touch.x > A3.x && touch.x < A4.x && touch.y > A3.y {
            return .south
        }else{
            return .center
        }
        
    }
    
    /// 根据手势改变裁剪框大小
    ///
    /// - Parameters:
    ///   - point: tapPorint
    ///   - dx: x offset
    ///   - dy: y offset
    func updateRect(point:CGPoint,dx:CGFloat,dy:CGFloat) {
        
        let area =  self.touchLocation(touch: point, insetFrame: insetRect!)
        
        let rect = self.rectfree(area: area, dx: dx, dy: dy)
        
        
        if rect.size.height < 100 || rect.size.width < 150 {
            return
        }
        func updateFrame(rect:CGRect) {
            if originalFrame?.contains(rect) == true {
                self.frame = rect
            }
        }
        
        let edge = self.edgeInsetforScrollView(clipRect: rect)
        
        edageClosure?(edge)
        updateFrame(rect: rect)
        
    }
    
    func edgeInsetforScrollView(clipRect:CGRect) -> UIEdgeInsets {
        var edge = UIEdgeInsets.zero
        let orx = originalFrame?.origin.x
        let ory = originalFrame?.origin.y
        let orW = originalFrame?.size.width
        let orH = originalFrame?.size.height
        
        let nowx = clipRect.origin.x
        let nowy = clipRect.origin.y
        let nowW = clipRect.size.width
        let nowH = clipRect.size.height
        switch orientation {
        case .left:
            edge = UIEdgeInsets.init(top: abs(nowx-orx!), left:orH! - abs(nowy - ory!)  - nowH , bottom: abs(orW!) - abs(nowx-orx!) - nowW , right: abs(nowy - ory!))
        case .right:
            edge =  UIEdgeInsets.init(top: abs(orW!) - abs(nowx-orx!) - nowW, left: abs(nowy - ory!), bottom: abs(nowx-orx!) , right: orH! - abs(nowy - ory!)  - nowH)
        case .up:
            edge =  UIEdgeInsets.init(top: abs(nowy - ory!), left: abs(nowx-orx!), bottom: orH! - abs(nowy - ory!)  - nowH , right: abs(orW!) - abs(nowx-orx!) - nowW)
        case .down:
            edge =  UIEdgeInsets.init(top: orH! - abs(nowy - ory!)  - nowH, left: abs(orW!) - abs(nowx-orx!) - nowW, bottom: abs(nowy - ory!), right: abs(nowx-orx!))
        default:
            edge =  UIEdgeInsets.init(top: abs(nowy - ory!), left: abs(nowx-orx!), bottom: orH! - abs(nowy - ory!)  - nowH , right: abs(orW!) - abs(nowx-orx!) - nowW)
        }
        
        return edge
    }
    func rect4to3(area:TouchLocation,dx:CGFloat,dy:CGFloat) -> CGRect {
        
        let originFrame = self.frame
        let W = originFrame.size.width
        let H = originFrame.size.height
        let x = originFrame.origin.x
        let y = originFrame.origin.y
        
        var rect:CGRect = CGRect.init()
        
        switch area {
            
        case .center:
            rect = CGRect.init(x: x - dx, y: y - dy, width: W, height: H)
        case .east_north:
            if dx > 0 && dy < 0{
                rect = CGRect.init(x: x , y: y + abs(dy) , width: W - abs(dx), height: 3/4 * (W - abs(dx)))
            }else if dx < 0 && dy > 0{
                rect = CGRect.init(x: x, y: y - abs(dy), width: W + abs(dx), height: 3/4 * (W + abs(dx)))
            }
        case .east_south:
            if dx < 0 && dy < 0{
                rect = CGRect.init(x: x, y: y , width: W + abs(dx), height: 3/4 * (W + abs(dx)))
            }else if dx > 0 && dy > 0{
                rect = CGRect.init(x: x , y: y , width: W - abs(dx), height: 3/4 * (W - abs(dx)))
            }
        case .west_north:
            if dx < 0 && dy < 0{
                rect = CGRect.init(x: x + abs(dx), y: y + abs(dy) , width: W - abs(dx), height: 3/4 * (W - abs(dx)))
            }else if dx > 0 && dy > 0{
                rect = CGRect.init(x: x - abs(dx), y: y - abs(dy), width: W + abs(dx), height:3/4 * (W + abs(dx)))
            }
        case .west_south:
            if dx > 0 && dy < 0{
                rect = CGRect.init(x: x - abs(dx), y: y, width: W + abs(dx), height: 3/4 * (W + abs(dx)))
            }else if dx < 0 && dy > 0{
                rect = CGRect.init(x: x + abs(dx), y: y , width: W - abs(dx), height: 3/4 * (W - abs(dx)))
            }
        case .north:
            if  dy > 0{
                if  H - abs(dy) > 3/4 * W  {
                    rect = CGRect.init(x: x , y: y + abs(dy) , width: W , height: 3/4 * W)
                }else{
                    rect = CGRect.init(x: x, y: y - abs(dy), width: 4/3 * (H + abs(dy)) , height: H + abs(dy))
                }
                
            }else if  dy < 0{
                if  H - abs(dy) > 3/4 * W  {
                    rect = CGRect.init(x: x , y: y + abs(dy) , width: W , height: 3/4 * W)
                }else{
                    rect = CGRect.init(x: x , y: y + abs(dy) , width:4/3 * (H - abs(dy)) , height: H - abs(dy))
                }
            }
        case .south:
            if dy < 0{
                if  H - abs(dy) > 3/4 * W  {
                    rect = CGRect.init(x: x , y: y + abs(dy) , width: W , height: 3/4 * W)
                }else{
                    rect = CGRect.init(x: x , y: y , width: 4/3 * (H + abs(dy)) , height: H + abs(dy))
                }
            }else if dy > 0{
                if  H - abs(dy) > 3/4 * W  {
                    rect = CGRect.init(x: x , y: y + abs(dy) , width: W , height: 3/4 * W)
                }else{
                    rect = CGRect.init(x: x , y: y , width: 4/3 * (H - abs(dy)) , height: H - abs(dy))
                }
            }
        case .west:
            if dx > 0 {
                if  W + abs(dx) > 4/3 * H  {
                    rect = CGRect.init(x: x , y: y + abs(dy) , width: 4/3 * H , height: H)
                }else{
                    rect = CGRect.init(x: x - abs(dx), y: y , width: W + abs(dx), height:  3/4 * (W + abs(dx)))
                }
            }else if dx < 0 {
                if W - abs(dx) > 4/3 * H  {
                    rect = CGRect.init(x: x , y: y + abs(dy) , width: 4/3 * H , height: H)
                }else{
                    rect = CGRect.init(x: x + abs(dx), y: y , width: W - abs(dx), height: 3/4 * (W - abs(dx)))
                }
            }
        case .east:
            if dx > 0 {
                if W - abs(dx) > 4/3 * H  {
                    rect = CGRect.init(x: x , y: y + abs(dy) , width: 4/3 * H , height: H)
                }else{
                    rect = CGRect.init(x: x , y: y , width: W - abs(dx), height: 3/4 * (W - abs(dx)))
                }
            }else if dx < 0 {
                if  W + abs(dx) > 4/3 * H  {
                    rect = CGRect.init(x: x , y: y + abs(dy) , width: 4/3 * H , height: H)
                }else{
                    rect = CGRect.init(x: x , y: y , width: W + abs(dx), height: 3/4 * (W + abs(dx)))
                }
            }
        }
        
        return rect
    }
    
    func rectfree(area:TouchLocation,dx:CGFloat,dy:CGFloat) -> CGRect {
        
        let originFrame = self.frame
        let W = originFrame.size.width
        let H = originFrame.size.height
        let x = originFrame.origin.x
        let y = originFrame.origin.y
        var rect:CGRect = CGRect.init()
        
        switch area {
        case .center:
            rect = CGRect.init(x: x - dx, y: y - dy, width: W, height: H)
        case .east_north:
            if dx > 0 && dy < 0{
                rect = CGRect.init(x: x , y: y + abs(dy) , width: W - abs(dx), height: H - abs(dy))
            }else if dx < 0 && dy > 0{
                rect = CGRect.init(x: x, y: y - abs(dy), width: W + abs(dx), height: H + abs(dy))
            }
        case .east_south:
            if dx < 0 && dy < 0{
                rect = CGRect.init(x: x, y: y , width: W + abs(dx), height: H + abs(dy))
            }else if dx > 0 && dy > 0{
                rect = CGRect.init(x: x , y: y , width: W - abs(dx), height: H - abs(dy))
            }
        case .west_north:
            if dx < 0 && dy < 0{
                rect = CGRect.init(x: x + abs(dx), y: y + abs(dy) , width: W - abs(dx), height: H - abs(dy))
            }else if dx > 0 && dy > 0{
                rect = CGRect.init(x: x - abs(dx), y: y - abs(dy), width: W + abs(dx), height: H + abs(dy))
            }
        case .west_south:
            if dx > 0 && dy < 0{
                rect = CGRect.init(x: x - abs(dx), y: y, width: W + abs(dx), height: H + abs(dy))
            }else if dx < 0 && dy > 0{
                rect = CGRect.init(x: x + abs(dx), y: y , width: W - abs(dx), height: H - abs(dy))
            }
        case .north:
            if  dy > 0{
                rect = CGRect.init(x: x, y: y - abs(dy), width: W , height: H + abs(dy))
            }else if  dy < 0{
                rect = CGRect.init(x: x , y: y + abs(dy) , width: W , height: H - abs(dy))
            }
        case .south:
            if dy < 0{
                rect = CGRect.init(x: x , y: y , width: W , height: H + abs(dy))
            }else if dy > 0{
                rect = CGRect.init(x: x , y: y , width: W , height: H - abs(dy))
            }
        case .west:
            if dx > 0 {
                rect = CGRect.init(x: x - abs(dx), y: y , width: W + abs(dx), height: H)
            }else if dx < 0 {
                rect = CGRect.init(x: x + abs(dx), y: y , width: W - abs(dx), height: H)
            }
        case .east:
            if dx > 0 {
                rect = CGRect.init(x: x , y: y , width: W - abs(dx), height: H)
            }else if dx < 0 {
                rect = CGRect.init(x: x , y: y , width: W + abs(dx), height: H)
            }
            
        }
        
        return rect
        
    }
    
    /// override point
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        super.point(inside: point, with: event)
        self.insetRect = frame.insetBy(dx: 30, dy: 30)
        
        let p =   self.convert(point, to: self.superview!)
        
        let location = self.touchLocation(touch: p, insetFrame: self.insetRect!)
        self.removeImageClosure?()
        if location == .center && self.closure?() == false {
            return false
        }else{
            return true
        }
        
    }
    
}

