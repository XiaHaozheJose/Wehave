//
//  WHHomeTopViewController.swift
//  Wehave
//
//  Created by 浩哲 夏 on 2018/2/17.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit

class WHHomeTopView: UIView {
    
    // Data
    
    fileprivate var pageControl: UIPageControl?
    fileprivate var time: Timer?
    fileprivate var images: [String] = ["image1","image2","image3"]
    fileprivate var menuTitles: [String] = ["Ofrecer".localized,"Comprado".localized,"Vendido".localized]
    
    enum MenuItem: Int {
        case OFRECER = 0
        case COMPRADO = 1
        case VENDIDO = 2
    }
    
    fileprivate lazy var whellView: JCyclePictureView = {
        let scroll = JCyclePictureView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kWheelHeight),pictures: images)
        scroll.placeholderImage = #imageLiteral(resourceName: "image3")
        scroll.direction = .left
        scroll.autoScrollDelay = 3
        scroll.pageControlStyle = .center
        scroll.pageControl.currentPageIndicatorTintColor = ThemeColor
        scroll.pageControl.pageIndicatorTintColor = UIColor.lightGray
        return scroll
    }()
    
    lazy var menuView: UIView = {
        let menu = UIView(frame: CGRect(x: 0, y: kWheelHeight, width: kScreenWidth, height: kMenuHeight + kCommonMargin))
        menu.backgroundColor = .white
        return menu
    }()
    
    
    var callBackMenuItem: ((_ index: Int)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupMenu()
        setWheelView()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - UI
extension WHHomeTopView{
    
    
    /// Config Menu
    fileprivate func setupMenu(){
        let bottomView = UIView(frame: CGRect(x: 0, y: kMenuHeight, width: kScreenWidth, height: kCommonMargin))
        bottomView.backgroundColor = .lightGray
        menuView.addSubview(bottomView)
        
        for index in 0 ..< 3 {
            addMenuItem(index: index)
        }
    }
    
    
    
    
    fileprivate func setup(){
        addSubview(whellView)
        addSubview(menuView)
    }
    
    
    /// Click Wheel Image
    fileprivate func setWheelView(){
        whellView.didTapAtIndexHandle = { index in
            
        }
    }
    
    
    private func addMenuItem(index: Int){
        let width = kScreenWidth / 4
        let margin = (kScreenWidth - (width * 3)) / 4
        let button = UIButton(frame: CGRect(x: CGFloat(index) * (width  + margin) + margin, y: 0, width: width, height: kMenuHeight))
        button.setTitle(menuTitles[index], for: .normal)
        button.setImage(UIImage(named: "home_menu_" + "\(index)"), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.titleEdgeInsets = UIEdgeInsetsMake(button.imageView!.height + 5,
                                                  -(button.imageView!.width),
                                                  0, 0)
        button.imageEdgeInsets = UIEdgeInsetsMake(0, button.titleLabel!.width / 2,
                                                  button.titleLabel!.height + 5,
                                                  -(button.titleLabel!.width / 2))
        button.tag = index
        button.addTarget(self, action: #selector(didSelectMenuItem(button:)), for: .touchUpInside)
        menuView.addSubview(button)
    }
    
    
    @objc private func didSelectMenuItem(button: UIButton){
        callBackMenuItem?(button.tag)
    }
    
}


