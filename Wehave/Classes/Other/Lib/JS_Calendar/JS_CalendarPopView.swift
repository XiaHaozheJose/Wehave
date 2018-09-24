//
//  JS_CalendarPopView.swift
//  JS_Calendar
//
//  Created by JS_Coder on 2018/3/30.
//  Copyright © 2018年 JS_Coder. All rights reserved.
//

import UIKit
enum JS_CalendarPopViewPosition: Int {
    case POP_LEFT
    case POP_MIDDLE
    case POP_RIGHT
    case NONE
}

class JS_CalendarPopView: UIView {
    
    fileprivate  let popArrowHeight: CGFloat = 7
    fileprivate  let popViewAlpha: CGFloat = 0.5
    
    
    fileprivate var arrowPosition: JS_CalendarPopViewPosition = .NONE
    fileprivate var sideRect: CGRect!
    fileprivate var drawArrowStartX: CGFloat = 0
    
    var topText: String?{
        didSet{
            topLabel.text = topText
            updateUI()
        }
    }
    var bottomText: String?{
        didSet{
            bottomLabel.text = bottomText
            updateUI()
        }
    }
    
    lazy var topLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()
    
    lazy var bottomLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textAlignment = .center
        return label
    }()
    
    lazy var backgroundView: UIView = {
        let bg = UIView()
        bg.layer.cornerRadius = 5.0
        bg.backgroundColor = UIColor.black.withAlphaComponent(popViewAlpha)
        return bg
    }()
    
    
    init(sideView: UIView, arrowPosition: JS_CalendarPopViewPosition) {
        super.init(frame: CGRect())
        self.arrowPosition = arrowPosition
        sideRect = getFrameInWindow(view: sideView)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getFrameInWindow(view: UIView)->CGRect{
        guard let rect = view.superview?.convert(view.frame, to: UIApplication.shared.keyWindow) else { return view.frame}
        return rect
    }
    
    func showAnimation() {
        if self.superview == nil {
            UIApplication.shared.keyWindow?.addSubview(self)
        }
        self.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.25) {
            self.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
        }
    }
    
    fileprivate func setupUI(){
        self.backgroundColor = .clear
        
        self.addSubview(backgroundView)
        
        backgroundView.addSubview(topLabel)
        
        backgroundView.addSubview(bottomLabel)
        
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: drawArrowStartX, y: rect.size.height))
        path.addLine(to:CGPoint(x: drawArrowStartX - popArrowHeight, y: rect.size.height - popArrowHeight))
        path.addLine(to: CGPoint(x: drawArrowStartX + popArrowHeight, y: rect.size.height - popArrowHeight))
        path.close()
        UIColor.clear.withAlphaComponent(popViewAlpha).setFill()
        path.fill()
    }
    
    func updateUI(){
        let topRect = sizeWithText(label: topLabel)
        let bottomRect = sizeWithText(label: bottomLabel)
        let width = max(topRect.size.width, bottomRect.size.width) + 20
        var x: CGFloat = 0
        
        if arrowPosition == .POP_LEFT {
            x = sideRect.origin.x + 10
        }else if arrowPosition == .POP_MIDDLE{
            x = sideRect.midX - width / 2
        }else {
            x = sideRect.origin.x + sideRect.size.width - width - 10
        }
        let height: CGFloat = 50
        self.frame = CGRect(x: x, y: sideRect.origin.y - height - popArrowHeight, width: width, height: height + popArrowHeight)
        backgroundView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        topLabel.frame = CGRect(x: 0, y: 13, width: width, height: 12)
        bottomLabel.frame = CGRect(x: 0, y: 28, width: width, height: 10)
        setLayoutAnchorPoint()
    }
    
    func sizeWithText(label: UILabel) -> CGRect {
        let nilRect = CGRect(x: 0, y: 0, width: 0, height: 0)
        guard let _ = label.text else {return nilRect}
        let attributes = [NSAttributedStringKey.font: label.font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect:CGRect = label.text!.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)), options: option, attributes: attributes, context: nil)
        return rect;
    }
    
    private func setLayoutAnchorPoint(){
        if arrowPosition == .POP_LEFT {
            drawArrowStartX = sideRect.size.width / 2 - 10
        }else if arrowPosition == .POP_MIDDLE{
            drawArrowStartX = self.frame.width / 2
        }else {
            drawArrowStartX = self.frame.size.width - sideRect.size.width / 2 + 10
        }
        self.layer.anchorPoint = CGPoint(x: drawArrowStartX / self.frame.size.width, y: 1)
    }
}
