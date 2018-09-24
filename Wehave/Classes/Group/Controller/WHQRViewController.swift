//
//  WHQRViewController.swift
//  Wehave
//
//  Created by JS_Coder on 2018/7/12.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit
import AVFoundation
class WHQRViewController: UIViewController {

 
    @IBOutlet weak var scanBackGround: UIView!
    @IBOutlet weak var topLine: NSLayoutConstraint!
    @IBOutlet weak var scanAnimate: UIImageView!
    @IBOutlet weak var scanQRImage: UIImageView!
    
    @IBOutlet weak var qrContentLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Escanear".localized
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Volver".localized, style: .done, target: self, action: #selector(backToSuperView))
        startScan()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        starAnimate()
        
    }
    //预览层<相机>
    fileprivate var previewLayer:AVCaptureVideoPreviewLayer?
    //捕捉会话
    fileprivate lazy var session: AVCaptureSession? = {
        //创建捕捉会话
        let session = AVCaptureSession()
        
        //拿到设备摄像头<如果设备是坏的就返回nil>
        guard let cameraDevice = AVCaptureDevice.default(for:.video)else{return nil }
        //让摄像头 成为输入对象
        guard let inputDevice = try? AVCaptureDeviceInput.init(device: cameraDevice)else{return nil}
        
        //创建输出对象
        let output = AVCaptureMetadataOutput()
        //设置输出 代理<线程注意>
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        //判断输入和输出 是否能被添加
        if session.canAddInput(inputDevice)&&session.canAddOutput(output){
            session.addInput(inputDevice)
            session.addOutput(output)
            //## 注意设置码Type 必须在添加输出输入之后
            output.metadataObjectTypes = [.qr]
            
            //限制扫描区域< 这里的坐标是按手机横屏的坐标>
            let x: CGFloat = self.scanBackGround.frame.origin.y / self.view.bounds.height
            let y: CGFloat = self.scanBackGround.frame.origin.x / self.view.bounds.width
            let width: CGFloat = self.scanBackGround.frame.height / self.view.bounds.height
            let height: CGFloat = self.scanBackGround.frame.width / self.view.bounds.width
            output.rectOfInterest = CGRect.init(x: x, y: y, width: width, height: height)
        }
        
        //添加摄像头的预览图层<否则看不到图形>
        let layer = AVCaptureVideoPreviewLayer.init(session: session)
        layer.frame = self.view.bounds
        self.view.layer.insertSublayer(layer,at:0)
        self.previewLayer = layer
        return session
    }()
    
    
    
}

extension WHQRViewController{
    /// 开始动画
    fileprivate func starAnimate(){
        UIView.animate(withDuration: 1.5) {
            // 改变网格图片的约束
            self.topLine.constant = 0
            UIView.setAnimationRepeatCount(MAXFLOAT)
            self.view.layoutIfNeeded()
        } }
    
    fileprivate func startScan(){
        session?.startRunning()
    }
    fileprivate func endScan(){
        session?.stopRunning()
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension WHQRViewController:AVCaptureMetadataOutputObjectsDelegate{
    
    //当扫描到东西就会来这个方法
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
    
        //每次进来做预防先删除边框
        self.removeBorder()
        
        //将扫描到的转为QRCode
        guard let metadataObjects = metadataObjects as? [AVMetadataMachineReadableCodeObject] else { return }
        
        //便利结果数组,给扫描到的二维码添加边框
        _ = metadataObjects.map{setBorderForQR(metadataObject: $0)
            if let content = $0.stringValue{
                qrContentLabel.text = content
            }
    }
    
}
    
    
    /// 给扫到的二维码 添加边框
    ///
    /// - Parameter metadataObject:
    private func setBorderForQR(metadataObject:AVMetadataMachineReadableCodeObject){
        
        //需要使用视频预览图层将数据坐标转换为我们可以识别到的坐标<默认情况下为机器码>
        guard  let metadataObject = previewLayer?.transformedMetadataObject(for: metadataObject) as?AVMetadataMachineReadableCodeObject else {return}
        
        let path = UIBezierPath()
        //获取坐标<从字典里取CFDictionary>
        for (index,point) in metadataObject.corners.enumerated(){
            //根据坐标形成路径
            if index == 0 {
                path.move(to: point)
            }else{
                path.addLine(to: point)
            }
        }
        //关闭路径
        path.close()
        
        //创建shapeLayer图形 根据路径画图
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = 3
        shapeLayer.strokeColor = UIColor.green.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        //将图形添加到 预览层上
        previewLayer?.addSublayer(shapeLayer)
    }
    
    //移除边框<不在捕捉状态>
    private func removeBorder(){
        _ = previewLayer?.sublayers?.reversed().map{if $0 is CAShapeLayer{$0.removeFromSuperlayer()}}
    }
    
   @objc private func backToSuperView(){
        self.dismiss(animated: true, completion: nil)
    }
}
