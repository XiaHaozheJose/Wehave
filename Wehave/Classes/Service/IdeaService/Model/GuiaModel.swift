//
//  GuiaModel.swift
//  Wehave
//
//  Created by JS_Coder on 2018/7/6.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import Foundation

class GuiaModel:NSObject{
    @objc var htmlStr: String?
    @objc var createTime: String?
    var longitud: Double?
    var latitud: Double?
    @objc var guia_token: String?
    @objc var user_token: String?
    
    init(dict:[String: Any]) {
        super.init()
        for key in dict.keys{
            switch key {
            case "latitud":
                latitud = dict[key] as? Double
            case "longitud":
                longitud = dict[key] as? Double
            case "user_token":
                user_token = dict[key] as? String
            case "html":
                htmlStr = dict[key] as? String
            case "time":
                createTime = dict[key] as? String
            case "gui_token":
                guia_token = dict[key] as? String
            default: break
            }
        }
    }
    
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
