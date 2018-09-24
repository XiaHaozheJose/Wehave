//
//  WHTarBarController.swift
//  Wehave
//
//  Created by 浩哲 夏 on 2018/2/16.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit

class WHTarBarController: UITabBarController {

   
    fileprivate let arrayDict = [
        [ClassName:"WHBaseHomeViewController",TabTitle: "WeHave",TabImageName: "home"],
        [ClassName:"WHBaseGroupViewController",TabTitle: "Mensaje".localized,TabImageName: "social"],
        [ClassName:"WHDiscoveryViewController",TabTitle: "Descubre".localized,TabImageName: "discovery"],
        [ClassName:"WHProfileViewController",TabTitle: "Mio".localized,TabImageName: "mi"]
    ]
    
    
    override func loadView() {
        super.loadView()
        let tab =  UITabBarItem.appearance()
        tab.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 11)], for: .normal)
        tab.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 11)], for: .selected)
//        tab.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.black], for: .normal)
//        tab.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.black], for: .selected)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        changeTabBarToCustom()
        NotificationCenter.default.addObserver(self, selector: #selector(showService), name: serviceNotification, object: nil)
    }
}


// MARK: - SETUP UI
extension WHTarBarController{
    
    fileprivate func setup(){
        setChildsControlleres()
    }
    
    private func changeTabBarToCustom(){
        let tabBar = WHTabBar(frame: self.tabBar.frame)
        tabBar.tintColor = ThemeColor
        setValue(tabBar, forKey: "tabBar")
    }
    
    private func setChildsControlleres(){
        for dict in arrayDict{
            addChildViewController(controller(dict: dict))
        }
    }
    
    private func controller(dict:[String: String])->UIViewController{
        guard let clsName = dict[ClassName],
              let title = dict[TabTitle],
              let imageName = dict[TabImageName],
        let cls = NSClassFromString(Bundle.main.namespace + "." + clsName) as? UIViewController.Type
        else {
            return UIViewController()
        }
        let vc = cls.init()
        vc.title = title
        
        //Image
        vc.tabBarItem.image = UIImage(named:imageName)
        vc.tabBarItem.selectedImage = UIImage(named:imageName + "HL")?.withRenderingMode(.alwaysOriginal)
        vc.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:ThemeColor], for:.selected)
        let WHNaviChild = WHNavigationController(rootViewController: vc)
        return WHNaviChild
    }
}

// MARK: - Show ServerView
extension WHTarBarController{
    @objc private func showService(){
        print("service")
        // Inilizer View
        let serviceView = WHServiceView.serviceView()
        //Show View
        serviceView.show {[weak serviceView] (clsName) in
            //  Create Controller
            guard let className = clsName,
                let cls = NSClassFromString(Bundle.main.namespace + "." + className) as? UIViewController.Type else { serviceView?.removeFromSuperview();  return }
            let vc = cls.init()
            let nav = WHNavigationController(rootViewController: vc)
            self.present(nav, animated: true){
                serviceView?.removeFromSuperview()
            }
        }
    }
}
