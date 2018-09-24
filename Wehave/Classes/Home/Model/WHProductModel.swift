//
//  WHNewsModel.swift
//  Wehave
//
//  Created by 浩哲 夏 on 2018/2/25.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import Foundation

//APIs PRODUCTS KEYS
enum PRODUCTS_KEYS: String {
    case ID = "id"
    case TITLE = "title"
    case CONTENT = "content"
    case PRICE = "price"
    case IMAGES = "images"// split with ;
    case DATE = "date" // can be null
    case LOCALIDAD = "localidad"
    case USER_TOKEN = "userToken"
    case PRODUCT_TOKEN = "productToken"
    case PRODUCT_USER_IMAGE = "productUserImage"
    case PRODUCT_USER_NAME = "productUserName"
}
class WHProductModel: NSObject {
    
    @objc var icon_image: String = ""
    @objc var user_name: String = "Jose"
    @objc var creatTime: String = "Hace 1 Hora"
    @objc var price: Double = 0
    @objc var title: String = ""
    @objc var content: String = "IPhone 7 Muy Nuevo  Solomente para hoy  IPhone 7 Muy Nuevo  "
    @objc var ubication: String = "Madrid"
    @objc var userToken: String = ""
    @objc var product_images: String = ""
    @objc var productToken: String = ""
    
    init(dict:[String: AnyObject]) {
        super.init()

        for key in dict.keys{
            switch key {
            case PRODUCTS_KEYS.TITLE.rawValue:
                self.title = dict[key] as! String
                
            case PRODUCTS_KEYS.CONTENT.rawValue:
                self.content = dict[key] as! String
                
            case PRODUCTS_KEYS.PRICE.rawValue:
                self.price = dict[key] as! Double

            case PRODUCTS_KEYS.IMAGES.rawValue:
                self.product_images = dict[key] as! String

            case PRODUCTS_KEYS.DATE.rawValue:
                self.creatTime = dict[key] as! String

            case PRODUCTS_KEYS.LOCALIDAD.rawValue:
                self.ubication = dict[key] as! String

            case PRODUCTS_KEYS.USER_TOKEN.rawValue:
                self.userToken = dict[key] as! String

            case PRODUCTS_KEYS.PRODUCT_USER_IMAGE.rawValue:
                self.icon_image = dict[key] as! String

            case PRODUCTS_KEYS.PRODUCT_USER_NAME.rawValue:
                self.user_name = dict[key] as! String

            case PRODUCTS_KEYS.PRODUCT_TOKEN.rawValue:
                self.productToken = dict[key] as! String
            default: break
                
            }
        }
        
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}
