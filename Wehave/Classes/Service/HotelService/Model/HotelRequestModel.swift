//
//  HotelRequestModel.swift
//  Wehave
//
//  Created by JS_Coder on 2018/3/19.
//  C.......................................................................................≥≥≥≥k,opyright © 2018年 浩哲 夏. All rights reserved.
//

import Foundation


class HotelRequest: NSObject {

    

   @objc var Street: String = "" // Calle 街道
   @objc var ZIP: String = ""    // Codigo Postal 邮编
   @objc var Country: String = "" // Pais 国家
   @objc var SubThoroughfare: String = "" // sub Calle 子街道
   @objc var State: String = ""  // 州
   @objc var Name: String = ""  //  Nombre De Calle 街道名
   @objc var SubAdministrativeArea: String = "" // 管区 zona
   @objc var Thoroughfare: String = "" //
   @objc var City: String = ""  // ciudad 城市
   @objc var CountryCode: String = ""  // Codigo De Pais 国家代码
   @objc var SubLocality: String = ""  // 子区域
    
    init(dict:[String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }

    
}
