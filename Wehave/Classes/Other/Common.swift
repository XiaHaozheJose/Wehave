//
//  Common.swift
//  Wehave
//
//  Created by 浩哲 夏 on 2018/2/16.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit

// MARK: - Default Color
let ThemeColor = UIColor(hexString: "#FED953") ?? UIColor.white
let ThemeNorColor = UIColor.lightText
let ThemeBackgroundColor = UIColor(hexString: "#F5F5F5")
let random = Float(arc4random_uniform(256))/255.0

// MARK: - Default Frame
let kScreenWidth = UIScreen.main.bounds.width
let kScreenHeight = UIScreen.main.bounds.height
let kScreenBounds = UIScreen.main.bounds


let kWheelHeight: CGFloat = 150
let kMenuHeight: CGFloat = 120
let kNavigationBarHeight: CGFloat = UIApplication.shared.keyWindow?.rootViewController?.navigationController?.navigationBar.frame.height ?? 64
let kTabBarHeight: CGFloat = UIApplication.shared.keyWindow?.rootViewController?.tabBarController?.tabBar.frame.height ?? 49
let kCommonMargin: CGFloat = 10
let kHomeCellHeight: CGFloat = 300 + kCommonMargin
let kCollectionItemHeight: CGFloat = 120
let kCalendarHeight: CGFloat = kScreenHeight * 3 / 2
let kChatBubbleWidth: CGFloat = kScreenWidth * 2 / 3


// MARK: - Default String
let ClassName = "clsName"
let TabTitle = "title"
let TabImageName = "imageNames"
let EUR = "€"
let DATA_NAME = "Wehave"
let AutoLogin = "autoLogin"
// URL
let Amadeus_APIs_Url = "https://api.sandbox.amadeus.com"
let Amadeus_Hotel_Circle_Search = "/v1.2/hotels/search-circle?"
let Amadeus_apikey = "HeUzlbUHoP90NnQFHGsmBiXwiVNXOmJ5"
let WEHAVE_BASIC_LOCAL_APIs = "http://23.97.138.23:8181/"
//let WEHAVE_BASIC_LOCAL_APIs = "http://localhost:8181/"
//let WEHAVE_BASIC_LOCAL_APIs_Images = "http://localhost:8181/Images?path="
let WEHAVE_BASIC_LOCAL_APIs_Images = "http://23.97.138.23:8181/Images?path="
let SMS_INSTASENT_TOKEN = "0bee4c5898709226b7a55690b62bf2f0530d55cf"
let SMS_INSTASENT_URL = "https://api.instasent.com/sms/"
// Key For APIs


enum OTA: Int {
    case ACCESSIBLE_FACILITIES = 47 //无障碍通道
    case ELEVATOR = 33 // 电梯
    case PARKING = 68 //停车场
    case TOUR = 91 //
    case PETS = 224
    case SAFE_DEPOSIT_BOX = 78
    case AC_220V = 115
    case BUS_PARKING = 192
    case FRONT_DESK_24_HOURS = 1
    case INDOOR_PARKING = 53
    case LAUNDRY_SERVICE = 58
    case COFFEE_SHOP = 20
    case RESTAURANT = 76
    case LOUNGE_BARS = 165
    case CAR_RENTAL = 15
    case CURRENCY_EXCHANGE = 26
    case BALLROOM = 191
    case ROOM_SERVICE = 77
    case EXECUTIVE_FLOOR = 34
    case POOL = 71 //
    case OUTDOOR_POOL = 66
    case BABY_SITTING = 8 // Cuidad El Bebe
    case HOTSPOTS = 221 // Internet
    case WIRELESS = 179 // Internet
    case FREE_HIGH_SPEED_INTERNET = 222 // Internet
    case INTERNET_SERVICES = 223 // Internet
    case INTERNET_PUBLIC_AREAS = 178 // Internet
    case BEAUTY_SALON = 107
    case CHILDREN_WELCOME = 218
    case DISCO = 195
    case GIFT_SHOP = 45
    case JACUZZI = 55
    case MULTILINGUAL_STAFF = 103 // 多语言
    case NIGHTCLUB = 62
    case SAUNA = 79
    
}
