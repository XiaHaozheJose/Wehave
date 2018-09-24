//
//  QRClearImage.swift
//  QRCode
//
//  Created by 浩哲 夏 on 2017/3/4.
//  Copyright © 2017年 浩哲 夏. All rights reserved.
//

import UIKit

extension UIImage{
    
   /// 将QRCode转换为自定义大小图片
   /// - Parameters:
   ///   - image: outPutImage
   ///   - size: SizeForImage
   /// - Returns: UIimage
   class func createClearImage(_ image : CIImage, size : CGFloat ) -> UIImage? {
        
        // 1.获取图片的尺寸,并调整小数像素到整数像素,将origin下调(12.3->12),size上调(11.5->12)
        let extent = image.extent.integral
        
        // 2.取出指定大小的最小比例
        let scale = min(size / extent.width, size/extent.height)
        
        // 3.将图片放大到指定比例
        let width = extent.width * scale
        let height = extent.height * scale
        // 3.1创建依赖于设备的灰度颜色通道
        let cs = CGColorSpaceCreateDeviceGray();
        // 3.2创建位图上下文
        let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: 0)
        
        // 4.创建上下文
        let context = CIContext(options: nil)
        
        // 5.将CIImage转为CGImage
        let bitmapImage = context.createCGImage(image, from: extent)
        
        // 6.设置上下文渲染等级
        bitmapRef!.interpolationQuality = .none
        
        // 7.设置缩放比例
        bitmapRef?.scaleBy(x: scale, y: scale)
        
        // 8.绘制一张图片在位图上下文中
        bitmapRef?.draw(bitmapImage!, in: extent)
        
        // 9.从位图上下文中取出图片(CGImage)
        guard let scaledImage = bitmapRef?.makeImage() else {return nil}
        
        // 10.将CGImage转为UIImage并返回
        return UIImage(cgImage: scaledImage)
    }
}
