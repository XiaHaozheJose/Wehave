//
//  JS_Image container.swift
//  Wehave
//
//  Created by JS_Coder on 2018/6/7.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit

class JS_ImageContainer: UIImageView {
    
    var imageView = UIImageView()
    var clipImageView = JS_ClipImageView.init(frame: CGRect.zero)
    var newImageView = UIImageView()
    var newClipImageView = UIImageView()
    var grayCoverView:UIView = UIView()
    
    lazy var bottomBar: UIView = {
        let bar = UIView(frame: CGRect(x: 0, y: kScreenHeight - 49, width: kScreenWidth, height: 49))
        bar.backgroundColor = UIColor(hexString: "#479cf2")
        return bar
    }()
    

    var hwRate:CGFloat = 1
    var angle = 0.0
    var orientation:UIImageOrientation = .up
    var scrollContentView = SourceImageView()
    var editBackImage:((UIImage?)->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(hexString: "#212121")
        UIApplication.shared.statusBarStyle = .lightContent
        imageView = UIImageView.init()
        imageView.contentMode = UIViewContentMode.scaleAspectFit
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setup(){
        addSubview(bottomBar)
        let saveBtn = UIButton(frame: CGRect.init(x: kScreenWidth - 100 - kCommonMargin, y: 0 , width: 100 , height: 50))
        saveBtn.setTitle("Save", for: UIControlState.normal)
        saveBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        bottomBar.addSubview(saveBtn)
        saveBtn.addTarget(self, action: #selector(saveImage), for: UIControlEvents.touchUpInside)
        
        
        let cancelBtn = UIButton(frame: CGRect.init(x:kCommonMargin, y: 0 , width: 100 , height: 50))
        cancelBtn.setTitle("Cancel", for: UIControlState.normal)
        cancelBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        bottomBar.addSubview(cancelBtn)
        cancelBtn.addTarget(self, action: #selector(cancelEdit), for: UIControlEvents.touchUpInside)
        
        let rotateBtn = UIButton(frame: CGRect.init(x: kScreenWidth / 2 - 25, y: 0, width: 50, height: 50))
        rotateBtn.setImage(UIImage.init(named: "-photo_btn_rotate"), for: UIControlState.normal)
        bottomBar.addSubview(rotateBtn)
        rotateBtn.addTarget(self, action: #selector(rotateImage), for: UIControlEvents.touchUpInside)
        
    }
    
    /// load view
    /// - Parameter data: binarydata
    func imageData(data:Data)  {
        let image = UIImage.init(data: data)
        imageView.center.x = self.center.x
        imageView.center.y = self.center.y
        
        hwRate = (image?.size.height)!/(image?.size.width)!
        var w = kScreenWidth - 30
        var h =  (kScreenWidth - 30) * hwRate
        
        
        if h > kScreenHeight  - 100 - 20 {
            h = kScreenHeight  - 100 - 20
            w = h / hwRate
        }
        
        imageView.bounds.size = CGSize.init(width: w, height: h)
        imageView.image = image
        
        scrollContentView = SourceImageView.init(frame: imageView.frame)
        self.addSubview(scrollContentView)
        scrollContentView.contentImg.image = image
        
        grayCoverView.frame = self.frame
        grayCoverView.isUserInteractionEnabled = false
        grayCoverView.backgroundColor = UIColor.black
        grayCoverView.alpha = 0.7
        grayCoverView.isHidden = true
        self.addSubview(grayCoverView)
        
        clipImageView.frame = imageView.frame
        clipImageView.isUserInteractionEnabled = true
        clipImageView.originalFrame = imageView.frame
        clipImageView.image = UIImage.init(named: "camer_aaperture")
        self.addSubview(clipImageView)
        
        clipImageView.closure = {[weak self] in
            if (self?.scrollContentView.contentScr.zoomScale)! > 1 {
                return false
            }
            return true
        }
        clipImageView.pinchClosure = {[weak self] (scale:CGFloat) in
            self?.scrollContentView.contentScr.zoomScale = scale
        }
        
        clipImageView.edageClosure = {[weak self] (edage:UIEdgeInsets) in
            self?.scrollContentView.edageScrollInset? = edage
        }
        clipImageView.clipClosure = {[weak self] in
            self?.clipImage()
        }
        clipImageView.removeImageClosure = {[weak self]in
            self?.removeclipImage()
        }
        scrollContentView.snapClosure = {[weak self] in
            
            self?.clipImageView.clipTimeFire()
        }
        setup()
    }
    
    
    /// Rotation
    @objc func rotateImage()  {
        
        self.removeclipImage()
        var w = kScreenWidth - 30
        var h = (kScreenWidth - 30) * hwRate
        let imgMaxHeight = kScreenHeight  - 100 - 20
        
        angle = angle + Double.pi / 2
        
        if angle == Double.pi / 2 + 2 * Double.pi {
            angle = Double.pi / 2
        }
        
        switch angle {
        case Double.pi / 2:
            orientation = .right
            imageView.center.x = self.center.x
            imageView.center.y = self.center.y - 50
            if h > w {
                h = w
                w = h / hwRate
            }else{
                w = kScreenHeight - 200
                h = w * hwRate
            }
        case Double.pi:
            orientation = .down
            if h > imgMaxHeight {
                h = imgMaxHeight
                w = h / hwRate
            }
        case 3 * Double.pi / 2:
            orientation = .left
            imageView.center.x = self.center.x
            imageView.center.y = self.center.y - 50
            if h > w {
                h = w
                w = h / hwRate
            }else{
                w = kScreenHeight - 200
                h = w * hwRate
            }
        case 2*Double.pi:
            orientation = .up
            if h > imgMaxHeight {
                h = imgMaxHeight
                w = h / hwRate
            }
        default:
            return
        }
        imageView.bounds.size = CGSize.init(width: w, height: h)
        imageView.transform = CGAffineTransform.init(rotationAngle: CGFloat(angle))
        clipImageView.transform =  imageView.transform
        clipImageView.orientation = orientation
        
        scrollContentView.transform = imageView.transform
        scrollContentView.frame = imageView.frame
        scrollContentView.contentScr.frame = imageView.bounds
        scrollContentView.contentScr.zoomScale = 1.0
        scrollContentView.contentImg.frame = imageView.bounds
        scrollContentView.edageScrollInset = UIEdgeInsets.zero
        scrollContentView.contentScr.contentInset = UIEdgeInsets.zero
        scrollContentView.contentScr.contentSize = imageView.bounds.size
        clipImageView.frame =  CGRect.init(x: imageView.x + 2, y: imageView.y + 2, width: imageView.width - 4, height: imageView.height - 4)
        clipImageView.originalFrame = imageView.frame
        
    }
    
    /// save Photo
    @objc func saveImage()  {
        
        if let image = self.clipImageFromImageView() {
            UIImageWriteToSavedPhotosAlbum(image, self,#selector(self.image(image:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    @objc private func cancelEdit(){
        editBackImage?(image)
    }
    
    /// callback to finish
    ///
    /// - Parameters:
    ///   - image:
    @objc func image(image:UIImage,didFinishSavingWithError error:NSError?,contextInfo:AnyObject) {
        
        if error != nil {
            
        } else {
            editBackImage?(image)
        }
    }
    
    /// remove clip Image
    func removeclipImage()  {
        newImageView.removeFromSuperview()
        newClipImageView.removeFromSuperview()
        grayCoverView.isHidden = true
    }
    
    
    /// clip image
    func clipImage() {
        
        if let image = self.clipImageFromImageView() {
            newImageView.frame = clipImageView.frame
            self.addSubview(newImageView)
            newImageView.image = image
            
            newClipImageView.frame = newImageView.frame
            self.addSubview(newClipImageView)
            newClipImageView.image = UIImage.init(named: "camer_aaperture")
            
            grayCoverView.isHidden = false
        }
        
    }
    
    /// get image from imageView
    ///
    /// - Returns: image
    func clipImageFromImageView() -> UIImage?  {
        
        var clipRatioX:CGFloat = 1
        var clipRatioY:CGFloat = 1
        
        let zoomScale = scrollContentView.contentScr.zoomScale
        let imgW = (self.imageView.image?.size.width)!
        let imgH = (self.imageView.image?.size.height)!
        let imageViewW = self.imageView.frame.size.width
        let imageViewH = self.imageView.frame.size.height
        
        switch orientation {
        case .right,.left:
            clipRatioX = imgH/(imageViewW * zoomScale)
            clipRatioY = imgW/(imageViewH * zoomScale)
        default:
            clipRatioX = imgW/(imageViewW * zoomScale)
            clipRatioY = imgH/(imageViewH * zoomScale)
        }
        let rect = self.clipImageView.convert(self.clipImageView.bounds, to: scrollContentView.contentScr)
        
        return  self.imageView.image?.clipToSquare(area: rect, ratioX: clipRatioX, ratioY: clipRatioY, orientation: orientation)
        
    }
    
    
}




