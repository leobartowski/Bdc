//
//  Date - Ext.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 23/10/21.
//

import Foundation

extension Date {
    
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow: Date { return Date().dayAfter }

    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self.noon) ?? Date()
    }

    var twoDayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -2, to: self.noon) ?? Date()
    }

    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self.noon) ?? Date()
    }
    
    var twoDayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 2, to: self.noon) ?? Date()
    }

    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self) ?? Date()
    }

    var previousMonth: Date {
        return Calendar.current.date(byAdding: .month, value: -1, to: self) ?? Date()
    }

    var nextMonth: Date {
        return Calendar.current.date(byAdding: .month, value: +1, to: self) ?? Date()
    }

    var previousWeek: Date {
        return Calendar.current.date(byAdding: .weekOfYear, value: -1, to: self) ?? Date()
    }

    var nextWeek: Date {
        return Calendar.current.date(byAdding: .weekOfYear, value: 1, to: self) ?? Date()
    }

    /// Get first day of the month
    func getStartOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self))) ?? Date()
    }
    /// Get last day of the month
    func getEndOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.getStartOfMonth()) ?? Date()
    }
    
    /// Get first day of the year
    func getStartOfYear() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year], from: Calendar.current.startOfDay(for: self))) ?? Date()
    }
    /// Get last day of the year
    func getEndOfYear() -> Date {
        return Calendar.current.date(byAdding: DateComponents(year: 1, day: -1), to: self.getStartOfYear()) ?? Date()
    }

    /// Get the month number and the year
    func getMonthAndYearNumber() -> (monthNumber: Int, yearNumber: Int) {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2
        calendar.locale = .current
        calendar.minimumDaysInFirstWeek = 4
        let monthNumber = calendar.component(.month, from: self)
        let yearNumber = calendar.component(.year, from: self)
        return (monthNumber, yearNumber)
    }

    /// Get the Week Number in the year
    func getWeekNumber() -> Int {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2
        calendar.locale = .current
        calendar.minimumDaysInFirstWeek = 4
        return calendar.component(.weekOfYear, from: self)
    }

    /// Get Specific day of the week of the given day (1: Sunday, 2: Monday, ..., 7: Saturday)
    func getSpecificDayOfThisWeek(_ dayInt: Int) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.weekOfYear, .yearForWeekOfYear], from: self)
        components.weekday = dayInt
        let sundayInWeek = calendar.date(from: components)
        return sundayInWeek ?? Date()
    }

    /// Returns an integer from 1 - 7, with 1 being Sunday and 7 being Saturday
    func getDayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }

    func getAllDateOfTheWeek() -> [Date] {
        var calendar = Calendar.autoupdatingCurrent
        calendar.firstWeekday = 2 // / Week start on Monday (or 1 for Sunday)
        let today = calendar.startOfDay(for: self)
        var week = [Date]()
        if let weekInterval = calendar.dateInterval(of: .weekOfYear, for: today) {
            for i in 0 ... 6 {
                if let day = calendar.date(byAdding: .day, value: i, to: weekInterval.start) {
                    week += [day]
                }
            }
        }
        return week
    }
    
    /// Get all Dates of the month of the date
    func getAllDateOfTheMonth() -> [Date] {
        var dates: [Date] = []
        var date = self.getStartOfMonth()
         
        while date <= self.getEndOfMonth() {
             dates.append(date)
             guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
             date = newDate
         }
         return dates
    }
    
    /// Get all Dates of the year
    func getAllDateOfTheYear() -> [Date] {
        var dates: [Date] = []
        var date = self.getStartOfYear()
         
        while date <= self.getEndOfYear() {
             dates.append(date)
             guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
             date = newDate
         }
         return dates
    }

    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }

    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }

    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }

    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }

    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }

    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }

    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
}
