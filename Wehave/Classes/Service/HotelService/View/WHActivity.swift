//
//  WHActivity.swift
//  Wehave
//
//  Created by JS_Coder on 2018/5/9.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit

class WHActivity: UIActivity {

    fileprivate var title: String?
    fileprivate var image: UIImage?
    fileprivate var url: URL?
    fileprivate var type: String?
    fileprivate var context: [Any]?
    convenience init(title: String? = "Wehave",activityImage: UIImage? = #imageLiteral(resourceName: "JS_QRCode"), activityUrl: URL? = (URL.init(string: "https://www.google.es"))!,activityType: String = "", shareText: [Any]) {
        self.init()
        self.title = title
        self.image = activityImage
        self.url = activityUrl
        self.type = activityType
        self.context = shareText
    }
    override func prepare(withActivityItems activityItems: [Any]) {
        print(activityItems)
    }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        if activityItems.count > 0 {
            return true
        }
        return false
    }
    
    override func perform() {
        if let url = self.url {
            if UIApplication.shared.canOpenURL(url){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            self.activityDidFinish(true)
        }
    }

}
