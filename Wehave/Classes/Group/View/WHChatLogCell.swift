//
//  WHChatLogCell.swift
//  Wehave
//
//  Created by JS_Coder on 2018/6/19.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
class WHChatLogCell: WHBaseFriendCell {
    
    
    private let iconWH:CGFloat = 40
    
    private let messageText: UILabel = {
        let textView = UILabel()
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.lineBreakMode = .byWordWrapping
        textView.numberOfLines = 0
        textView.textColor = .black
        textView.backgroundColor = .clear
        return textView
    }()
    
    private let textBubbleView: UIView = {
        let bubble = UIView()
        bubble.backgroundColor = .clear
        bubble.layer.cornerRadius = 15
        bubble.layer.masksToBounds = true
        return bubble
    }()
    
    fileprivate let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    fileprivate let bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    
    var message: Message?{
        didSet{
            if let message = message,let text = message.text,let iconImage = message.friends?.profileIcon{
                messageText.text = text
                let size = text.getSizeWithTextWith(textFont: 18, maxSize: CGSize(width: self.bounds.width * 2 / 3, height: CGFloat(MAXFLOAT)))
                if !message.isSender!.boolValue{// Not Sender
                    removeAllConstraints()
                    profileImageView.image = UIImage(named:iconImage)
                    profileImageView.snp.makeConstraints { (make) in
                        make.leading.equalToSuperview().offset(kCommonMargin)
                        make.width.height.equalTo(iconWH)
                        make.top.equalToSuperview()
                    }
                    
                    messageText.snp.makeConstraints { (make) in
                        make.leading.equalTo(profileImageView.snp.trailing).offset(kCommonMargin * 2)
                        make.width.equalTo(size.width + kCommonMargin)
                        make.height.equalTo(size.height + kCommonMargin * 2)
                        make.top.equalToSuperview().offset(0.5 * kCommonMargin)
                    }
                    
                    textBubbleView.snp.makeConstraints { (make) in
                        make.leading.equalTo(profileImageView.snp.trailing)
                        make.width.equalTo(size.width + kCommonMargin * 3)
                        make.height.equalTo(size.height + kCommonMargin * 3)
                        make.top.equalToSuperview()
                    }
                    
                    bubbleImageView.image = #imageLiteral(resourceName: "bubble_blue").resizableImage(withCapInsets: UIEdgeInsets(top: 25, left: 30 , bottom: 25, right: 30)).withRenderingMode(.alwaysTemplate)
                    bubbleImageView.tintColor = UIColor(white: 0.90, alpha: 1)
                    messageText.textColor = .black
                }else{// isSender
                    removeAllConstraints()
                    profileImageView.image = #imageLiteral(resourceName: "profileIcon")
                    profileImageView.snp.makeConstraints { (make) in
                        make.trailing.equalToSuperview().offset(-kCommonMargin)
                        make.width.height.equalTo(iconWH)
                        make.top.equalToSuperview()
                    }
                    
                    messageText.snp.makeConstraints { (make) in
                        make.trailing.equalTo(profileImageView.snp.leading).offset(-kCommonMargin * 1)
                        make.width.equalTo(size.width + kCommonMargin)
                        make.height.equalTo(size.height + kCommonMargin * 2)
                        make.top.equalToSuperview().offset(kCommonMargin * 0.5)
                    }
                    textBubbleView.snp.makeConstraints { (make) in
                        make.trailing.equalTo(profileImageView.snp.leading).offset(-kCommonMargin * 0.5)
                        make.width.equalTo(size.width + kCommonMargin * 3)
                        make.height.equalTo(size.height + kCommonMargin * 3)
                        make.top.equalToSuperview()
                    }
                    bubbleImageView.image = #imageLiteral(resourceName: "bubble_gray").resizableImage(withCapInsets: UIEdgeInsets(top: 25, left: 30 , bottom: 25, right: 30)).withRenderingMode(.alwaysTemplate)
                    bubbleImageView.tintColor = ThemeColor
                    messageText.textColor = .white
                }
            }
        }
    }
    
    
    
    
    override func setup() {
        super.setup()
        setMessageTextView()
    }
    
    private func setMessageTextView(){
        addSubview(textBubbleView)
        addSubview(messageText)
        addSubview(profileImageView)
        
        textBubbleView.addSubview(bubbleImageView)
        bubbleImageView.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    
    private func removeAllConstraints(){
        profileImageView.snp.removeConstraints()
        messageText.snp.removeConstraints()
        textBubbleView.snp.removeConstraints()
    }
    
    
}
