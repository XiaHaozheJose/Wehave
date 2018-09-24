//
//  HotelCalendarModel.swift
//  Wehave
//
//  Created by JS_Coder on 2018/3/31.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import Foundation
class HotelBooking: NSObject{
    static let shared = HotelBooking()
    class func shred()->HotelBooking{
        return shared
    }
    
    var location: String = "Loading"
    var startDate: String = ""
    var endDate: String = ""
    var countDate: String = ""
    var roomsCount: String = ""
    var adultCount: String = ""
    var childCount: String = ""
    var maxAmount: String = ""
    var requestStartDate: String = ""
    var requestEndDate: String = ""    
}
