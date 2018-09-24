//
//  WHOfferPhotosCell.swift
//  Wehave
//
//  Created by JS_Coder on 2018/6/28.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit

class WHOfferPhotosCell: UICollectionViewCell {
    
    
    private let imageWH: CGFloat = 64
    private let buttonWH: CGFloat = 30
    private var index: Int  = 0
    private var removeItem: ((_ cell: WHOfferPhotosCell,_ index: Int)->())?
    lazy var photoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.frame = self.bounds
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    lazy var removeButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "service_close"), for: .normal)
        button.frame = CGRect(x: self.bounds.width - buttonWH, y: 0, width: buttonWH, height: buttonWH)
        button.addTarget(self, action: #selector(removeCurrentItem), for: .touchUpInside)
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setup(){
        addSubview(photoImage)
        addSubview(removeButton)
    }
    
    
    func setupImageView(photo: UIImage, index: Int, isUploadImage: Bool = false,didRemoveCellItem: @escaping ((_ cell: WHOfferPhotosCell,_ index: Int)->())){
        self.index = index
        self.removeItem = didRemoveCellItem
        if isUploadImage {
            photoImage.image = photo
            removeButton.isHidden = true
        }else{
            photoImage.image = photo
            removeButton.isHidden = false
        }
    }
    
    
    @objc private func removeCurrentItem(){
        removeItem?(self,index)
    }
}
