//
//  WHHomeTopMiddleCell.swift
//  Wehave
//
//  Created by 浩哲 夏 on 2018/2/17.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit
import SnapKit
class WHHomeTopMiddleCell: UIView {

    
   lazy var title: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
    return label
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    private func setup(){
        addSubview(title)
        addSubview(imageView)
        
        title.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(kCommonMargin)
            make.centerX.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { (make) in
            make.height.width.equalTo(64)
            make.centerX.equalToSuperview()
            make.top.equalTo(title.snp.bottom).offset(kCommonMargin)
        }
        
       
        
    }

}
