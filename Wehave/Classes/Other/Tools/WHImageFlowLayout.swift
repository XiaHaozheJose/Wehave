//
//  WHImageFlowLayout.swift
//  Wehave
//
//  Created by JS_Coder on 2018/4/5.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit

class WHImageFlowLayout: UICollectionViewFlowLayout {
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        guard let collection = self.collectionView else { return nil}
       
        for item in attributes {
            let dotCenter = fabs((item.center.x - collection.contentOffset.x) - collection.bounds.size.width * 0.5)
            let scale = 1 - dotCenter / (collection.bounds.size.width * 0.5) * 0.30
            item.transform = CGAffineTransform.init(scaleX: scale, y: scale)
        }
        return attributes
    }
    
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
       
        var pointX: CGFloat = 0
        if let collection = self.collectionView {
            let collectionWidth = collection.bounds.size.width
            let offsetX = proposedContentOffset.x
            
            let visableRect = CGRect(x: offsetX, y: 0, width: collectionWidth, height: collection.bounds.height)
            if let visableAtts = super.layoutAttributesForElements(in: visableRect) {
                var minDelta: CGFloat = CGFloat(MAXFLOAT)
                for attribut in visableAtts{
                    let delta = fabs((attribut.center.x - offsetX) - collectionWidth * 0.5)
                    if delta < fabs(minDelta){
                        minDelta = (attribut.center.x - offsetX) - collectionWidth * 0.5
                    }
                }
                
               pointX = proposedContentOffset.x + minDelta
                if pointX <= 0{
                    pointX = 0
                }
            }
        }
        return CGPoint(x: pointX, y: proposedContentOffset.y)
    }
    
    
    
    
    
}
