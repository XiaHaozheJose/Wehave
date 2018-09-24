//
//  WHChatLogFlowLayout.swift
//  Wehave
//
//  Created by JS_Coder on 2018/6/23.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit

class WHChatLogFlowLayout: UICollectionViewFlowLayout {
    var offset: CGFloat?
    
    override func prepare() {
        super.prepare()
        guard let offset = offset else { return }
        collectionView?.contentOffset = CGPoint(x: 0, y: offset)
    }
}
