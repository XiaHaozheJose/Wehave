//
//  WHLoginAnimationView.swift
//  Wehave
//
//  Created by JS_Coder on 2018/5/10.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit

class WHLoginAnimationView: UIView {

    @IBOutlet weak var leftHandImage: UIImageView!
    @IBOutlet weak var rightHandImage: UIImageView!
    @IBOutlet weak var leftArmImage: UIImageView!
    @IBOutlet weak var rightArmImage: UIImageView!
    @IBOutlet weak var armView: UIView!

    fileprivate var offsetLArmX: CGFloat = 0
    fileprivate var offsetLArmY: CGFloat = 0
    fileprivate var offsetRArmX: CGFloat = 0
    fileprivate var offsetRArmY: CGFloat = 0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // left arm offset
        offsetLArmX = leftArmImage.frame.origin.x
        offsetLArmY = armView.frame.size.height - leftArmImage.frame.origin.y
        
        offsetRArmX = armView.frame.size.width - rightArmImage.frame.maxX
        offsetRArmY = armView.frame.size.height - rightArmImage.frame.origin.y

        leftArmImage.transform = CGAffineTransform(translationX: -offsetLArmX, y: offsetLArmY)
        rightArmImage.transform = CGAffineTransform(translationX: offsetRArmX, y: offsetRArmY)
    }
    
    
    // open method
    func doAnimation(isStart: Bool) {
        if isStart {
            UIView.animate(withDuration: 0.25, animations: {
                self.rightArmImage.transform = .identity
                self.leftArmImage.transform = .identity
                
                // transform Hand
                let transformL = CGAffineTransform()
                self.leftHandImage.transform = transformL.scaledBy(x: 0.01, y: 0.01).translatedBy(x: -(self.offsetLArmX - self.leftHandImage.frame.width), y: -(self.offsetLArmY * 0.5))
                
                let transformR = CGAffineTransform()
                self.rightHandImage.transform = transformR.scaledBy(x: 0.01, y: 0.01).translatedBy(x: -(self.offsetRArmX), y: -(self.offsetRArmY * 0.5))
            })
        }else{
            UIView.animate(withDuration: 0.25, animations: {
                self.leftHandImage.transform = .identity
                self.rightHandImage.transform = .identity
                
                self.leftArmImage.transform = CGAffineTransform(translationX: -self.offsetLArmX, y: self.offsetLArmY);
                self.rightArmImage.transform = CGAffineTransform(translationX: self.offsetRArmX, y: self.offsetRArmY);
            })
        }
    }
    
    
    
}
