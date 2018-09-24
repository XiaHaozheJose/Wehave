//
//  QRCodeTool.swift
//  QRCode
//
//  Created by JS_Coder on 2017/3/4.
//  Copyright © 2017年 JS_Coder. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
// MARK: - 创建二维码
/// Creat QRCode With ContentText
class CreatQRCode {
    ///Object
    static let shareInstance = CreatQRCode()
    
    /// Option >>> The Color For QRCode
    var QRColor:UIColor? = UIColor.blue
    /// Option >>> The Color For BackGroundQR
    var QRBackGroundColor: UIColor? = UIColor.clear
    ///Content
    var QRContentText:String? = "SOY UN QRCode"
    ///QRCodeSize
    var QRSize: CGFloat? = 240
    ///SmallImage for custom
    var QRCenterImage:UIImage? = nil
    ///SmallImage Size
    var QRCenterImageSize:CGFloat? = 60
    
    
    
    /// Creat Simple QRCode
    ///
    /// - Parameter finished: returnQRCode
    func creatCode(finished:(UIImage?)->()){
        
        //获取QR过滤器
        guard let QRFilter = CIFilter(name: "CIQRCodeGenerator") else {return }
        //每次都需要 将过滤恢复默认模式<会有残留>
        QRFilter.setDefaults()
        //QR内容
        let content = QRContentText
        //转成Data类型
        let data = content?.data(using: .utf8)
        //内容传入QR
        QRFilter.setValue(data, forKey: "inputMessage")
        //设置QR修正等级 等级高的 可以自定义QR
        QRFilter.setValue("H", forKey: "inputCorrectionLevel")
        
        guard let outPutImage = QRFilter.outputImage else { return  }
        
        //从新画出图片<防止拉伸>
        guard let image = UIImage.createClearImage(outPutImage, size: QRSize!) else {return }
        //自定义QR颜色
        let imageCI = CIImage.init(image: image)
        guard let QRColorCI = CIFilter(name: "CIFalseColor") else { return  }
        QRColorCI.setValue(imageCI, forKey: "inputImage")
        
        let color0 = CIColor.init(color: QRColor!)
        QRColorCI.setValue(color0, forKey: "inputColor0")
        
        let color1 = CIColor.init(color: QRBackGroundColor!)
        QRColorCI.setValue(color1, forKey: "inputColor1")
        
        guard let colorImage = QRColorCI.outputImage else{return }
        
        let currentImage = UIImage.init(ciImage: colorImage)
        
        finished(setCustomCenterImage(QRCodeImage: currentImage, QRCenterImage:QRCenterImage, QRCenterImageSize: QRCenterImageSize))
        
    }
    
    private func setCustomCenterImage(QRCodeImage:UIImage,QRCenterImage:UIImage? = nil,QRCenterImageSize:CGFloat? = 0)->UIImage?{
        //<如果没有值直接返回CodeImage>
        if QRCenterImage == nil || QRCenterImageSize == 0 {return QRCodeImage}
        //获取原始code尺寸
        let CodeSize = QRCodeImage.size
        //开启图形上下文
        UIGraphicsBeginImageContext(CodeSize)
        // 1先将Code图画上去
        QRCodeImage.draw(in: CGRect.init(origin: CGPoint.zero, size: CodeSize))
        //2 再将centerImage画上去
        let x = (CodeSize.width - QRCenterImageSize!)*0.5
        let y = (CodeSize.height - QRCenterImageSize!)*0.5
        QRCenterImage?.draw(in: CGRect.init(x:x, y: y, width: QRCenterImageSize!, height: QRCenterImageSize!))
        //从上下文取出
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}

// MARK: - 识别二维码
/// DetecterQRCode And Return
class DetecterQRCode{
    
    /// 单例
    static let shareInstance = DetecterQRCode()
    // Color With Border
    var borderColor:UIColor? = UIColor.green
    //Width With Border
    var borderWidth:CGFloat? = 3
    //CGBlendMode
    var blendMode:CGBlendMode? = .darken
    
    
    /// DetecterQRCode
    ///
    /// - Parameters:
    ///   - originImage: source Image
    ///   - finished: Detected Image , ContentText With QRCode
    func DetecterCode(originImage:UIImage,finished:(UIImage?,[String?])->()){
        guard  let detector = CIDetector.init(ofType: CIDetectorTypeQRCode, context: CIContext(), options: [CIDetectorAccuracy:CIDetectorAccuracyHigh]) else {return }
        
        //探测图片的二维码特性
        let imageCode = originImage
        guard let imageCI = CIImage.init(image: imageCode) else {return }
        guard let feature = detector.features(in: imageCI)as? [CIQRCodeFeature] else {return }
        
        //把识别出来的二维码显示出来
        finished(dectetorQRCoder(originQRCode: imageCode, feature: feature),feature.map{$0.messageString})
    }
    
    // MARK: - 圈出识别的二维码
    fileprivate func dectetorQRCoder(originQRCode:UIImage,feature:[CIQRCodeFeature])->UIImage?{
        //图形上下文尺寸
        let size = originQRCode.size
        UIGraphicsBeginImageContext(size)
        originQRCode.draw(in: CGRect.init(origin: CGPoint.zero, size: size))
        
        //改变图形上下文的坐标系从左上角改为左下角
        let context = UIGraphicsGetCurrentContext()
        context?.scaleBy(x: 1, y: -1)//翻转
        context?.translateBy(x: 0, y: -size.height)
        
        _ = feature.map{let bezierPath = UIBezierPath.init(rect: $0.bounds)
            borderColor?.set()
            bezierPath.lineWidth = borderWidth!
            bezierPath.stroke(with:blendMode!, alpha: 1)}
        //取出图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}

// MARK: - 扫描二维码
/// Scan QRCode With Camera
class ScanQRCode:NSObject{
    
    
    /// 单例
    static let shareInstance = ScanQRCode()
    
    var borderWidth:CGFloat? = 4
    var strokeColor:UIColor? = UIColor.red
    var fillColor:UIColor? = UIColor.clear
    
    /// 视频预览图层
    fileprivate var previewLayer: AVCaptureVideoPreviewLayer?
    /// 捕捉会话
    fileprivate lazy var session: (UIView, UIView) -> AVCaptureSession? = { (scanView, superView) -> AVCaptureSession? in
        
        // .创建捕捉会话
        let session = AVCaptureSession()
        
        // .获取摄像驱动设备
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            return nil
        }
        //作为输入对象
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else {
            return nil
        }
        
        // .创建输出对象
        let output = AVCaptureMetadataOutput()
        
        // .设置输出对象的代理:扫描到结果会通过该代理通知外界
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        // .将输入和输出对象添加到会话中
        if session.canAddInput(input) && session.canAddOutput(output) {
            session.addInput(input)
            session.addOutput(output)
            
            // .1.设置支持的码制
            output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            // .2.限制扫描区域
            let x: CGFloat = scanView.frame.origin.y / superView.bounds.height
            let y: CGFloat = scanView.frame.origin.x / superView.bounds.width
            let w: CGFloat = scanView.frame.height / superView.bounds.height
            let h: CGFloat = scanView.frame.width / superView.bounds.width
            output.rectOfInterest = CGRect(x: x, y: y, width: w, height: h)
        }
        
        // 添加视频预览图层
        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer.frame = superView.bounds
        superView.layer.insertSublayer(layer, at: 0)
        self.previewLayer = layer
        return session
    }
    
    /// 获取二维码中的内容的回调闭包
    fileprivate var stringValue: ((String) -> ())?
}

// MARK: - 扫描二维码
extension ScanQRCode {
    func beginScanQRCoder(scanView: UIView, superView: UIView, stringValue:  @escaping (String) -> ()) {
        
        // 记录闭包
        self.stringValue = stringValue
        // 执行会话开始扫描
        session(scanView, superView)?.startRunning()
    }
}

extension ScanQRCode: AVCaptureMetadataOutputObjectsDelegate {
    // 当扫描任何码制的时候都会来到这个代理方法中
    // 这里仅仅只处理二维码
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        // .移除所有的边框
        removeBorder()
        // .将扫描到的结果转为扫描到二维码的结果
        guard let metadataObjects = metadataObjects as? [AVMetadataMachineReadableCodeObject] else {
            return
        }
        // 通过闭包回调数据
        if let string = metadataObjects.first?.stringValue {
            stringValue?(string)
        }
        // .遍历结果数组,给扫描到的二维码绘制边框
        _ = metadataObjects.map{drawQRCodeBorder(metadataObject: $0)}
    }
    
    
    /// 绘制二维码边框
    /// - Parameter metadataObject: 二维码的结果类型
    private func drawQRCodeBorder(metadataObject: AVMetadataMachineReadableCodeObject) {
        // 需要使用视频预览图层将数据坐标转换为我们可以识别到的坐标
        guard let metadataObject = previewLayer?.transformedMetadataObject(for: metadataObject) as? AVMetadataMachineReadableCodeObject else {
            return
        }
        
        // 从数组中将坐标字典取出来
        let path = UIBezierPath()
        for (index, dictCorner) in metadataObject.corners.enumerated() {
            let dictCF = dictCorner as! CFDictionary
            guard let point = CGPoint(dictionaryRepresentation: dictCF) else {
                return
            }
            
            if index == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        // 关闭路径
        path.close()
        
        // 创建形状图层
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = borderWidth!
        shapeLayer.strokeColor = strokeColor?.cgColor
        shapeLayer.fillColor = fillColor?.cgColor
        
        // 将形状图层添加到预览图层上
        previewLayer?.addSublayer(shapeLayer)
    }
    
    /// 移除边框
    private func removeBorder() {
        for sublayer in previewLayer?.sublayers?.reversed() ?? [] {
            if sublayer is CAShapeLayer {
                sublayer.removeFromSuperlayer()
            }
        }
    }
}


