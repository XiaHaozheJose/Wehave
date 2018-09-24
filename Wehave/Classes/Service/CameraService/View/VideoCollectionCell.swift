//
//  VideoCollectionCell.swift
//  Camera_Video
//
//  Created by 浩哲 夏 on 2017/11/25.
//  Copyright © 2017年 浩哲 夏. All rights reserved.
//

import UIKit

class VideoCollectionCell: UICollectionViewCell {
    
    var videoInterface: UIImageView?
    var effectView = UIVisualEffectView()
    var selectedButton = UIButton()
    var videoIsChoose: Bool?{
        willSet{
            selectedButton.isSelected = newValue!
            if newValue == true {
                effectView.alpha = 0
            }else{
                effectView.alpha = 0.4
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        videoIsChoose = false
        self.backgroundColor = UIColor.groupTableViewBackground
        makeInterFavceImage()
    }
    
    private func makeInterFavceImage(){
        videoInterface = UIImageView(frame: self.contentView.bounds)
        self.contentView.addSubview(videoInterface!)
        
        
        let playIconImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        playIconImageView.image = #imageLiteral(resourceName: "playIcon")
        playIconImageView.center = CGPoint(x: videoInterface!.bounds.width / 2, y: videoInterface!.bounds.height / 2)
        videoInterface?.addSubview(playIconImageView)
        
        selectedButton.frame = CGRect(x: 5, y: 5, width: 20, height: 20)
        selectedButton.setBackgroundImage(#imageLiteral(resourceName: "selected"), for: .selected)
        selectedButton.setBackgroundImage(#imageLiteral(resourceName: "unselected"), for: .normal)
        videoInterface?.addSubview(selectedButton)
        
        effectView.frame = videoInterface!.bounds
        effectView.effect = UIBlurEffect(style: .dark)
        effectView.alpha = 0.0
        videoInterface?.addSubview(effectView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
