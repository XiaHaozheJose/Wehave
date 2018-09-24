//
//  CreatQR.swift
//  QRCode
//
//  Created by 浩哲 夏 on 2017/3/4.
//  Copyright © 2017年 浩哲 夏. All rights reserved.
//

import UIKit

class CreatQR: UIViewController {


    lazy var QRImageView: UIImageView = {
        let image = UIImageView()
        image.frame.size = CGSize(width: kScreenWidth - 2 * kCommonMargin, height: kScreenWidth - 2 * kCommonMargin)
        image.center = self.view.center
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Volver".localized, style: .done, target: self, action: #selector(backToSuperView))
        self.title = "Código QR".localized
        view.addSubview(QRImageView)
    }
    
     func createQR(qrContent: String, qrImage: String){
    //获取QR过滤器
    guard let QRFilter = CIFilter(name: "CIQRCodeGenerator") else {return}
    //每次都需要 将过滤恢复默认模式<会有残留>
    QRFilter.setDefaults()
    //QR内容
    let content = qrContent
    //转成Data类型
    let data = content.data(using: .utf8)
    //内容传入QR
    QRFilter.setValue(data, forKey: "inputMessage")
    //设置QR修正等级 等级高的 可以自定义QR
    QRFilter.setValue("H", forKey: "inputCorrectionLevel")
    
    guard let outPutImage = QRFilter.outputImage else { return }
    guard let image = UIImage.createClearImage(outPutImage, size: QRImageView.bounds.size.width) else {return}
    //自定义QR颜色
    let imageCI = CIImage.init(image: image)
    guard let QRColor = CIFilter(name: "CIFalseColor") else { return  }
    QRColor.setValue(imageCI, forKey: "inputImage")
    
    let color0 = CIColor.init(color: UIColor.blue)
    QRColor.setValue(color0, forKey: "inputColor0")
    
    let color1 = CIColor.init(color: UIColor.white)
    QRColor.setValue(color1, forKey: "inputColor1")
    
    guard let colorImage = QRColor.outputImage else{return}
    
    let currentImage = UIImage.init(ciImage: colorImage)
    QRImageView.image = setCustomCenterImage(QRCodeImage: currentImage, QRCenterImage:#imageLiteral(resourceName: "profileIcon"), QRCenterImageSize: 60)
    }
    
    @objc private func backToSuperView(){
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension CreatQR{
    fileprivate func setCustomCenterImage(QRCodeImage:UIImage,QRCenterImage:UIImage? = nil,QRCenterImageSize:CGFloat? = 0)->UIImage?{
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
