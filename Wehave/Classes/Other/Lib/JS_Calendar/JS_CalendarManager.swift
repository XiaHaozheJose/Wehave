//
//  JS_CalendarManager.swift
//  JS_Calendar
//
//  Created by JS_Coder on 2018/3/29.
//  Copyright © 2018年 JS_Coder. All rights reserved.
//

import Foundation
class JS_CalendarManeger: NSObject{
    var currentDate: Date?
    var currentCompontents: DateComponents?
    var greCalendar: Calendar?
    var isShowHoliday: Bool = false
    var isShowChineseCalendar: Bool = false
    var startDate: Int = 0
    var dateFormatter: DateFormatter = DateFormatter()
    var startIndexPath: IndexPath?
    
    
    convenience init(showChineseHoliday: Bool, showChineseCalendar: Bool, startDate: Int ) {
        self.init()
        greCalendar = Calendar(identifier: .gregorian)
        currentDate = Date()
        guard let date = currentDate else {return }
        currentCompontents = dateToComponentes(date)
        self.startDate = startDate
        isShowHoliday = showChineseHoliday
        isShowChineseCalendar = showChineseCalendar
    }
    
    
    func getCalendarDataSource(limitMounth: Int, type: JS_CalendarViewType)->[JS_CalendarHeaderModel]?{
        var resultArray: [JS_CalendarHeaderModel] = [JS_CalendarHeaderModel]()
        guard var com = currentCompontents else {return nil}
        guard let _ = com.month else {return nil}
        currentCompontents?.day = 1
        if type == .NEXT_TYPE {
            com.month! -= 1;
        }else if type == .LAST_TYPE{
            com.month! -= limitMounth
        }else {
            com.month! -= (limitMounth + 1) / 2
        }
        for index in 0..<limitMounth {
            com.month! += 1
            com.day! = 1
            let headerModel = JS_CalendarHeaderModel()
            guard let date = componentesToDate(com: com)else {return nil}
            let month = Calendar.current.component(.month, from: date)
            dateFormatter.dateFormat = "yyyy"
            let yearStr = dateFormatter.string(from: date)
            headerModel.headerText = "\(months[month - 1]) - \(yearStr)"
            headerModel.calendarItemArray = getCalendarItemsWithDate(date: date, section: index)
            resultArray.append(headerModel)
        }
        return resultArray
    }
    
    private func dateToComponentes(_ date : Date)->DateComponents?{
        guard let calendar = greCalendar else {return nil}
        let com = calendar.dateComponents([.era,.year,.month,.day,.hour,.minute,.second], from: date)
        return com
    }
    
    private func componentesToDate(com: DateComponents)->Date?{
        let date = greCalendar?.date(from: com)
        return date
    }
    
    
    private func getCalendarItemsWithDate(date: Date, section: Int)->[JS_CalendarModel]?{
        var resultArray: [JS_CalendarModel] = [JS_CalendarModel]()
        let totalDay = numOfDaysInCurrentMonth(date: date)
        var firstWeekDay = startDayOfWeek(date: date)
        guard var components = dateToComponentes(date) else {return nil}
        firstWeekDay -= 1
        if firstWeekDay == 0 {
            firstWeekDay = 0
        }
        
        for _ in 0..<firstWeekDay{
            let model = JS_CalendarModel()
            resultArray.append(model)
        }
        for day in 1...totalDay {
            components.day! = day
            let model = JS_CalendarModel()
            model.day = day
            model.month = components.month!
            model.year = components.year!
            let kDate = componentesToDate(com: components)
            model.dateInterval = dateToInterval(date: kDate!)
            if startDate == model.dateInterval{
                startIndexPath = IndexPath(row: 0, section: section)
            }
            setHolidayWithDate(components: components, date: kDate!, calendarItem: model)
            resultArray.append(model)
        }
        return resultArray
    }
    
    private func numOfDaysInCurrentMonth(date:Date)->Int{
        guard let range = greCalendar?.range(of: .day, in: .month, for: date) else {return 0}
        return range.count
    }
    
    private func startDayOfWeek(date: Date) -> Int{
        let year = greCalendar?.dateComponents([.year], from: date)
        let month = greCalendar?.dateComponents([.month], from: date)
        let dateComponent = DateComponents(year: year?.year, month: month?.month)
        guard let week = greCalendar?.component(.weekday, from: (greCalendar?.date(from: dateComponent) ?? Date())) else {return 2}
        return week
    }
    
    private func dateToInterval(date: Date) -> Int{
        return Int(date.timeIntervalSince1970)
    }
    
    private func setHolidayWithDate(components: DateComponents, date: Date, calendarItem: JS_CalendarModel  ){
        guard let currentDate = currentDate else {return}
        guard let currentComponent = dateToComponentes(currentDate) else {return}

        if components.year == currentComponent.year && components.month == currentComponent.month && components.day == currentComponent.day {
            calendarItem.type = .CALENDAR_TODAY
            calendarItem.holiday = "HOY"
        }else {
            let result = date.compare(currentDate)
            if result.rawValue == 1 {
                calendarItem.type = .CALENDAR_NEXT
            }else{ calendarItem.type = .CALENDAR_LAST}
        }
        
        if(components.month == 1 && components.day == 1)
        {
            calendarItem.holiday =  "New Year";
        }
        else if(components.month == 2 && components.day == 14)
        {
            calendarItem.holiday =  "Valentine";
        }
        else if(components.month == 3 && components.day == 8)
        {
            calendarItem.holiday =  "Women's day";
        }
        else if(components.month == 4 && components.day == 1)
        {
            calendarItem.holiday =  "April Fools";
        }
        else if(components.month == 5 && components.day == 1)
        {
            calendarItem.holiday =  "Workers'Day";
        }
        else if(components.month == 5 && components.day == 4)
        {
            calendarItem.holiday =  "Youth day";
        }
        else if(components.month == 6 && components.day == 1)
        {
            calendarItem.holiday =  "Children's day";
        }
        else if(components.month == 9 && components.day == 10)
        {
            calendarItem.holiday =  "Teacher's day";
        }
        else if(components.month == 12 && components.day == 25)
        {
            calendarItem.holiday =  "Christmas";
        }
    }
}
