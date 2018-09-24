//
//  JS_CalendarModel.swift
//  JS_Calendar
//
//  Created by JS_Coder on 2018/3/29.
//  Copyright © 2018年 JS_Coder. All rights reserved.
//

import Foundation
enum JS_CalendarItemType: Int {
    case CALENDAR_TODAY
    case CALENDAR_LAST
    case CALENDAR_NEXT
    case NONE
}
class JS_CalendarModel: NSObject {
    
    @objc var year: Int = 0
    @objc var month: Int = 0
    @objc var day: Int = 0
    @objc var chineseCalendar: String = ""
    @objc var holiday: String = ""
    var type: JS_CalendarItemType = .CALENDAR_LAST
    @objc var dateInterval: Int = 999
    @objc var week: Int = 0
}
