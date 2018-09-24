//
//  WHBaseMessageViewController.swift
//  Wehave
//
//  Created by 浩哲 夏 on 2018/2/16.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit
import SnapKit
class WHBaseHomeViewController: UIViewController {
    
    
    var products: [WHProductModel]?{
        didSet{
            nearbyTableVC.products = products
            newsTableVC.products = products
        }
    }
    
    // titles Names
    let titles = ["Nuevo".localized,"Cerca".localized]
    
    // top Height
    let topHeight = kWheelHeight + kMenuHeight + kCommonMargin
    
    // newsTable
    lazy var newsTableVC: WHNewestNoticeController = {
        let tab = WHNewestNoticeController()
        tab.newestDelegate = self
        return tab
    }()
    // nearTable
    lazy var nearbyTableVC: WHNearbyViewController = {
        let tab = WHNearbyViewController()
        tab.nearbyDelegate = self
        return tab
    }()
    
    fileprivate var isCanScroll: Bool = true
    lazy var refreshView = JSRefreshControl()
    
    /// background scrollView
    lazy var backgroundScrollView: UIScrollView = {
        let scrollview = UIScrollView(frame: CGRect(x: 0, y: kNavigationBarHeight, width: kScreenWidth, height: kScreenHeight - kNavigationBarHeight-kTabBarHeight))
        scrollview.clipsToBounds = false
        scrollview.showsVerticalScrollIndicator = false
        scrollview.delegate = self
        scrollview.delaysContentTouches = false
        scrollview.contentSize.height = topHeight + kScreenHeight - kNavigationBarHeight
        scrollview.backgroundColor = .lightGray
        return scrollview
    }()
    
    /// TopView
    lazy var topView: WHHomeTopView = {
        let vc = WHHomeTopView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: topHeight))
        return vc
    }()
    
    /// pageView Style
    lazy var pageStyle: JS_PageStyle = {
        let titleFrame = CGRect(x: 0, y: kNavigationBarHeight, width: kScreenWidth, height: 49)
        var style = JS_PageStyle()
        style.titleNolmalColor = UIColor.lightGray
        style.titleSelectedColor = .black
        style.bottomLineColor = ThemeColor
        style.isNeedScale = true
        style.isShowCover = true
        style.coverPadding = kScreenWidth / 2.0 / CGFloat(titles.count)
        style.coverColor = ThemeColor
        style.titleFrame = titleFrame
        style.isTitleAddSuperView = true
        style.isTitleHidden = true
        style.contentFrame = CGRect(x: 0, y: 49, width: kScreenWidth, height: kScreenHeight - kNavigationBarHeight - titleFrame.height)
        return style
    }()
    
    /// PageView
    lazy var pageView: JS_PageView  = {
        let page = JS_PageView(frame: CGRect.init(x: 0, y: topHeight, width: kScreenWidth, height: kScreenHeight), titles: titles, style: self.pageStyle, childController: [newsTableVC,nearbyTableVC], parentController: self)
        return page
    }()
    
    
    lazy var loading: JSLoadingView = {
        let loading = JSLoadingView()
        loading.frame.size = CGSize(width: 50, height: 50)
        loading.center = self.view.center
        return loading
    }()
 
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: AutoLogin){
            _ = Profile.default.loadAccountData()
        }else{
            
        }
    }
    
    /// ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setup()
        loadData()
    }
    
}
// MARK: - UI
extension WHBaseHomeViewController{
    fileprivate func setup(){
        refreshView.addTarget(self, action: #selector(loadData), for: .valueChanged)
        view.addSubview(backgroundScrollView)
        backgroundScrollView.addSubview(topView)
        backgroundScrollView.addSubview(pageView)
        backgroundScrollView.addSubview(refreshView)
        
        // Trailing closure syntax
        topView.callBackMenuItem = {[weak self](index: Int) in
            switch index {
            case WHHomeTopView.MenuItem.OFRECER.rawValue:
                if Profile.default.token.count > 0, UserDefaults.standard.bool(forKey: AutoLogin){
                    let offerVc = WHOfferProductController()
                    let nav = WHNavigationController(rootViewController: offerVc)
                    self?.present(nav, animated: true, completion: {
                        offerVc.published = {
                            
                        }
                    })
                }else{
                    let loginVC = WHLoginViewController()
                    let nav = WHNavigationController(rootViewController: loginVC)
                    self?.present(nav, animated: true, completion: nil)
                }
                break
                
            case WHHomeTopView.MenuItem.COMPRADO.rawValue:
                print("Comprado")
                break
                
            case WHHomeTopView.MenuItem.VENDIDO.rawValue:
                print("Vendido")
                break
                
            default:
                return
            }
        }
    }
    
}

// MARK: - Selector | Target
extension WHBaseHomeViewController{
    @objc private func loadData(){
        refreshView.beginRefreshing()
        view.addSubview(loading)
        Networking.sharedInstance.getRequest(urlString: WEHAVE_BASIC_LOCAL_APIs+"product", success: {[weak self] (response) in
            self?.refreshView.endRefreshing()
            self?.loading.removeFromSuperview()
            var tmpProducts = [WHProductModel]()
            if let productos = response["Products"] as? [[String: AnyObject]]{
                for product in productos{
                    tmpProducts.append(WHProductModel(dict: product))
                }
            }
            self?.products = tmpProducts
        }) { [weak self](error) in
            print(error)
            self?.showAlert(title: "Error Internet o sin coneccion")
            self?.refreshView.endRefreshing()
            self?.loading.removeFromSuperview()
        }
        
    }
    
    private func showAlert(title: String){
        let alertController = UIAlertController(title: title,
                                                message: nil, preferredStyle: .alert)
        alertController.view.alpha = 0.8
        self.present(alertController, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.presentedViewController?.dismiss(animated: false, completion: nil)
        }
    }
    
    
}

// MARK: - UIScrollViewDelegate
extension WHBaseHomeViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageView.titleView.alpha = (scrollView.contentOffset.y / topHeight)
        if scrollView.contentOffset.y > 0 {
            scrollView.bounces = false
        }else{
            scrollView.bounces = true
        }
    }}


// MARK: - WHNewestTableViewDelegate
extension WHBaseHomeViewController: WHNewestTableViewDelegate{
    func tableViewDidScroll(scrollY: CGFloat,newTable: WHMuiltipleGestureTableView) {
        if newTable.contentOffset.y <= 0 { isCanScroll = true }else{
            let rect = self.topView.convert(topView.frame, from: self.view)
            if(isCanScroll && rect.origin.y < topHeight - kNavigationBarHeight){
                newTable.setContentOffset(CGPoint.zero, animated: false)
                isCanScroll = true
            }else{ isCanScroll = false
                backgroundScrollView.setContentOffset(CGPoint(x:0,y:topHeight), animated: false)
            }
        }
    }
}

// MARK: - WHNearbyTableViewDelegate
extension WHBaseHomeViewController: WHNearbyTableViewDelegate{
    func tableViewDidScroll(scrollY: CGFloat,nearbyTab: WHMuiltipleGestureTableView) {
        if nearbyTab.contentOffset.y <= 0 { isCanScroll = true }else{
            let rect = self.topView.convert(topView.frame, from: self.view)
            if(isCanScroll && rect.origin.y < topHeight - kNavigationBarHeight){
                nearbyTab.setContentOffset(CGPoint.zero, animated: false)
                isCanScroll = true
            }else{ isCanScroll = false
                backgroundScrollView.setContentOffset(CGPoint(x:0,y:topHeight), animated: false)
            }
        }
    }
}

