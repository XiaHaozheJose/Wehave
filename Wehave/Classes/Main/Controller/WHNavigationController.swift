//
//  WHNavigationController.swift
//  Wehave
//
//  Created by 浩哲 夏 on 2018/2/16.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit

class WHNavigationController: UINavigationController {

    
    override func loadView() {
        super.loadView()
        let naviBar = UINavigationBar.appearance()
        naviBar.barTintColor = ThemeColor
        naviBar.tintColor = .white
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
