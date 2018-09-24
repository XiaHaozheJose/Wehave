//
//  WHFriendCell.swift
//  Wehave
//
//  Created by JS_Coder on 2018/6/18.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit
import SnapKit
class WHFriendCell: WHBaseFriendCell {
    
    override var isHighlighted: Bool{
        didSet{
            backgroundColor = isHighlighted ? ThemeColor : .white
            messageLabel.textColor = isHighlighted ? .white : .darkGray
            timeLabel.textColor = isHighlighted ? .white : .black
            nameLabel.textColor = isHighlighted ? .white : .black
        }
    }
    
    
    var message: Message?{
        didSet{
            nameLabel.text = message?.friends?.name
            if let profileImage = message?.friends?.profileIcon {
                profileImageView.image = UIImage(named:profileImage)
            }
            messageLabel.text = message?.text
            if let date = message?.date {
                let dateFormater = DateFormatter()
                dateFormater.dateFormat = "hh:mm a"
                
                let elapsedTimeInSeconds = Date().timeIntervalSince(date)
                let secondsInDays: TimeInterval = 60 * 60 * 24
                let secondsInWeeks: TimeInterval = secondsInDays * 7
                
              
                if (elapsedTimeInSeconds > secondsInDays){
                    dateFormater.dateFormat = "EEE"
                    if (elapsedTimeInSeconds > secondsInWeeks){
                        dateFormater.dateFormat = "dd/MM/yyyy"
                    }
                }
                
                timeLabel.text = dateFormater.string(from: date)
            }
        }
    }
    
    var friend: Friend?{
        didSet{
            message = friend?.lastMessage
        }
    }
    
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "profileIcon")
        imageView.layer.cornerRadius = 35
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let dividerLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return line
    }()
    
    let nameLabel: UILabel = {
       let label = UILabel()
        label.text = "Name Label"
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    let messageLabel: UILabel = {
       let label = UILabel()
        label.text = "It's the message for you"
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
//        label.text = "12:05 pm"
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    
    override func setup() {
        
        addSubview(profileImageView)
        addSubview(dividerLine)
        
        
        profileImageView.snp.makeConstraints { (make) in
            make.height.width.equalTo(70)
            make.leading.equalToSuperview().offset(kCommonMargin)
            make.centerY.equalToSuperview()
        }
        
        dividerLine.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.leading.equalTo(profileImageView.snp.trailing).offset(kCommonMargin)
            make.trailing.equalToSuperview().offset(-kCommonMargin)
            make.bottom.equalToSuperview()
        }
        setContainerView()
    }
    
    
    private func setContainerView(){
        let containerView = UIView()
        addSubview(containerView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(messageLabel)
        containerView.addSubview(timeLabel)
        
        containerView.snp.makeConstraints { (make) in
            make.leading.equalTo(dividerLine.snp.leading)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().offset(-kCommonMargin)
            make.trailing.equalToSuperview().offset(-kCommonMargin)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(kCommonMargin)
            make.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(kCommonMargin)
        }
        messageLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(kCommonMargin)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-kCommonMargin * 2)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }
        
    }
    
    
    
}


class WHBaseFriendCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setup(){
    }
}
