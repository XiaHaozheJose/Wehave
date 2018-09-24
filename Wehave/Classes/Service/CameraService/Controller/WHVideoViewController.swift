//
//  WHVideoViewController.swift
//  Wehave
//
//  Created by JS_Coder on 2018/6/4.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit

// inherit WHCameraViewController
class WHVideoViewController: WHCameraViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        isVideo = true
        totalTimeLabel.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
