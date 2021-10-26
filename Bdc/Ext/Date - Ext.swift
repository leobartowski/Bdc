//
//  Date - Ext.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 23/10/21.
//

import Foundation

extension Date {
    
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    public var previousMonth: Date {
        return Calendar.current.date(byAdding: .month, value: -1, to: self) ?? Date()
    }
    var nextMonth: Date {
        return Calendar.current.date(byAdding: .month, value: +1, to: self) ?? Date()
    }
    
    func getSundayOfThisWeek() -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.weekOfYear, .yearForWeekOfYear], from: self)
        components.weekday = 1 // Sunday
        let sundayInWeek = calendar.date(from: components)
        return sundayInWeek ?? Date()
    }
    
    /// Returns an integer from 1 - 7, with 1 being Sunday and 7 being Saturday
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
    
    func getAllDateOfTheWeek() -> [Date] {
        
        var calendar = Calendar.autoupdatingCurrent
        //TODO: Check!
        calendar.firstWeekday = 2 // / Week start on Monday (or 1 for Sunday)
        let today = calendar.startOfDay(for: self)
        var week = [Date]()
        if let weekInterval = calendar.dateInterval(of: .weekOfYear, for: today) {
            for i in 0...6 {
                if let day = calendar.date(byAdding: .day, value: i, to: weekInterval.start) {
                    week += [day]
                }
            }
        }
        return week
    }
    
}
