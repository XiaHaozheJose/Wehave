//
//  WHShowProductViewController.swift
//  Wehave
//
//  Created by JS_Coder on 2018/7/4.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit
import Kingfisher
class WHShowProductViewController: UIViewController {

    
    lazy var baseScrollView: UIScrollView = {
        let scroll = UIScrollView(frame: self.view.bounds)
        return scroll
    }()
    
    
    /* user info*/
    lazy var iconImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    lazy var createLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()
    
    
    /* buy / edit */
    lazy var bottomButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = ThemeColor
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        return button
    }()
    
    lazy var line: UIView = {
        let line = UIView()
        line.backgroundColor = .lightGray
        return line
    }()
    
    var previousImage: UIImageView?
    
    fileprivate lazy var productTitle: UILabel = {
       let label = UILabel()
        label.frame.size = CGSize(width: 200, height: kNavigationBarHeight)
        label.textAlignment = .center
        return label
    }()
    
    fileprivate lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        return gradient
    }()
    fileprivate lazy var animation: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "locations")
        return animation
    }()
    
    lazy fileprivate var isAnimation: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ThemeBackgroundColor
        setup()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        productTitle.layer.removeAllAnimations()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setup(){
        iconImage.frame = CGRect(x: kCommonMargin, y: kCommonMargin, width: 50, height: 50)
        iconImage.layer.cornerRadius = 25
        iconImage.layer.masksToBounds = true
        userNameLabel.frame = CGRect(x: iconImage.frame.maxX + kCommonMargin, y: kCommonMargin,
                                     width:kScreenWidth - iconImage.frame.maxX - kCommonMargin, height: 25)
        createLabel.frame = CGRect(x: iconImage.frame.maxX + kCommonMargin, y: userNameLabel.frame.maxY + kCommonMargin * 0.5, width: kScreenWidth - iconImage.frame.maxX - kCommonMargin, height: 20)
        line.frame = CGRect(x: kCommonMargin, y: iconImage.frame.maxY + kCommonMargin * 2, width: kScreenWidth - kCommonMargin * 2, height: 0.5)
        priceLabel.frame = CGRect(x: kCommonMargin, y: line.frame.maxY + kCommonMargin * 2, width: 100, height: 25)
        bottomButton.frame = CGRect(x: 0, y: kScreenHeight - 49, width: kScreenWidth, height: 49)
        view.addSubview(baseScrollView)
        baseScrollView.addSubview(iconImage)
        baseScrollView.addSubview(userNameLabel)
        baseScrollView.addSubview(createLabel)
        baseScrollView.addSubview(priceLabel)
        baseScrollView.addSubview(contentLabel)
        baseScrollView.addSubview(line)
        view.addSubview(bottomButton)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "service_close").withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(closeViewController))
    }
    
    func setProductContent(product: WHProductModel){
        let iconPath = WEHAVE_BASIC_LOCAL_APIs_Images + product.icon_image
        iconImage.kf.setImage(with: URL(string: iconPath), placeholder: #imageLiteral(resourceName: "placeholder_icon_image"))
        userNameLabel.text = product.user_name
        createLabel.text = product.creatTime
        
        priceLabel.text = " \(EUR)\(product.price)"
        
        self.navigationItem.titleView = productTitle
        productTitle.text = product.title
        titleAnimation()
        
        let size = product.content.getSizeWithTextWith(textFont: 18, maxSize: CGSize(width: kScreenWidth - kCommonMargin * 2, height: CGFloat(MAXFLOAT)))
        contentLabel.frame = CGRect(x: kCommonMargin, y: priceLabel.frame.maxY + kCommonMargin * 2, width: kScreenWidth - kCommonMargin * 2, height: size.height + kCommonMargin * 2)
        contentLabel.text = product.content
        
        
        if Profile.default.token == product.userToken,UserDefaults.standard.bool(forKey: AutoLogin){
            bottomButton.setTitle("Edit", for: .normal)
        }else{
            bottomButton.setTitle("Comprar".localized, for: .normal)
        }
        
        let imagesArr = product.product_images.split(separator: ":")
        for (_,imagePath) in imagesArr.enumerated(){
            var imageY: CGFloat = 0
            
            if previousImage == nil{
                imageY = contentLabel.frame.maxY
            }else{
                imageY = previousImage!.frame.maxY
            }
            
            let imageView = UIImageView()
            let path = WEHAVE_BASIC_LOCAL_APIs_Images + imagePath
            let resource = ImageResource(downloadURL: URL.init(string: path)!)
            imageView.kf.setImage(with:resource, placeholder:#imageLiteral(resourceName: "profileIcon")) { (image, error, cacheType, url) in
                // some thing
                if let image = image{
                    imageView.frame = CGRect(x: 0, y: imageY + kCommonMargin, width: image.size.width, height: image.size.height)
                }
            }
            baseScrollView.addSubview(imageView)
            previousImage = imageView
            baseScrollView.contentSize = CGSize(width: kScreenWidth, height: previousImage!.frame.maxY + bottomButton.frame.height)
        }
        
    }
    
    @objc private func closeViewController(){
        self.dismiss(animated: true, completion: nil)
    }
    
    private func titleAnimation(){
        if isAnimation {
            return
        }
        
        gradient.frame = productTitle.bounds
        gradient.colors = [UIColor(white: 1.0, alpha: 0.3).cgColor, UIColor.yellow.cgColor, UIColor(white: 1.0, alpha: 0.3).cgColor]
        gradient.startPoint = CGPoint(x:-0.3, y:0.5)
        gradient.endPoint = CGPoint(x:1 + 0.3, y:0.5)
        gradient.locations = [0, 0.15, 0.3]
        productTitle.layer.mask = gradient
        animation.fromValue = [0, 0.15, 0.3]
        animation.toValue = [1 - 0.3, 1 - 0.15, 1.0];
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false
        animation.duration = 1.5
        gradient.add(animation, forKey: "titleAnimation")
        isAnimation = true
    }

}
