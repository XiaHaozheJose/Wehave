//
//  SourceImageView.swift
//  Wehave
//
//  Created by JS_Coder on 2018/6/6.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit
class SourceImageView: UIView {
    
    var contentScr : ImageScrollView!
    
    var contentImg : UIImageView!
    
    var edageScrollInset:UIEdgeInsets? = UIEdgeInsets.zero
    
    var snapClosure:(()->Void)?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        contentScr = ImageScrollView.init(frame: CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height))
        contentScr.delegate = self
        contentScr.minimumZoomScale = 1
        contentScr.maximumZoomScale = 2
        contentScr.showsVerticalScrollIndicator = false
        contentScr.showsHorizontalScrollIndicator = false
        self.addSubview(contentScr)
        
        contentImg = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: contentScr.frame.size.width, height: contentScr.frame.size.height))
        contentImg.contentMode = UIViewContentMode.scaleAspectFit
        contentScr.addSubview(contentImg)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

extension SourceImageView : UIScrollViewDelegate {
    
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentImg
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentInset = edageScrollInset ?? UIEdgeInsets.zero
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        snapClosure?()
    }
    
}

class ImageScrollView: UIScrollView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        super.point(inside: point, with: event)
        return true
    }
}
