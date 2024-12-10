//
//  Date - Ext.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 23/10/21.
//

import Foundation
import SwiftHoliday

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
    
    /// Get value of specifc component -> ex. retrive day of the month
    func getComponent(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
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
    func getMonthAndYearNumber() -> (m: Int, y: Int) {
        let month = Calendar.itBasic.component(.month, from: self)
        let year = Calendar.itBasic.component(.year, from: self)
        return (month, year)
    }
    
    /// Get the month number and the year
    func getWeekNumberAndYearNumber() -> (weekNumber: Int, yearNumber: Int) {
        let weekNumber = Calendar.itBasic.component(.weekOfYear, from: self)
        let yearNumber = Calendar.itBasic.component(.year, from: self)
        return (weekNumber, yearNumber)
    }
    
    /// Get the year number and the year
    func getYearNumber() -> Int {
        return Calendar.itBasic.component(.year, from: self)
    }
    
    /// Get the month number and the year
    func getWeekNumberAndYearForWeekOfYearNumber() -> (w: Int, y: Int) {
        let weekNumber = Calendar.itBasic.component(.weekOfYear, from: self)
        let yearNumber = Calendar.itBasic.component(.yearForWeekOfYear, from: self)
        return (weekNumber, yearNumber)
    }

    /// Get the Week Number in the year
    func getWeekNumber() -> Int {
        return Calendar.itBasic.component(.weekOfYear, from: self)
    }
    
    /// Get the day number of the month
    func getDayNumber() -> Int {
        return Calendar.itBasic.component(.day, from: self)
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

    func getAllSelectableDatesOfWeek(weeksOffset: Int = 0) -> [Date] {
        var calendar = Calendar.autoupdatingCurrent
        calendar.firstWeekday = 2 // Start week on Monday
        let today = calendar.startOfDay(for: self)
        var week = [Date]()
        if let weekInterval = calendar.dateInterval(of: .weekOfYear, for: today),
           let targetWeekStart = calendar.date(byAdding: .weekOfYear, value: weeksOffset, to: weekInterval.start) {
            for i in 0 ... 6 {
                if let day = calendar.date(byAdding: .day, value: i, to: targetWeekStart), day.isThisDaySelectable() {
                    week.append(day)
                }
            }
        }
        return week
    }
    
    func getAllDatesOfTheWeek() -> [Date] {
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
    
    /// Get all Selectable dates of months ago, no param means current month
    func getAllSelectableDatesOfMonth(ofMonthsAgo monthOffset: Int = 0) -> [Date] {
        var dates: [Date] = []
        guard let monthStart = Calendar.current.date(byAdding: .month, value: monthOffset, to: self.getStartOfMonth())
        else { return dates }
        let monthEnd = monthStart.getEndOfMonth()
        var date = monthStart
        while date <= monthEnd {
            if date.isThisDaySelectable() {
                dates.append(date)
            }
            guard let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = nextDate
        }
        return dates
    }
    
    /// Get all selectable dates of  years ago, no param means current year
    func getAllSelectableDateOfTheYear(ofYearsAgo yearOffset: Int = 0) -> [Date] {
        var dates: [Date] = []
        guard let yearStart = Calendar.current.date(byAdding: .year, value: yearOffset, to: self.getStartOfYear())
        else { return dates}
        let yearEnd = yearStart.getEndOfYear()
        var date = yearStart
        while date <= yearEnd {
            if date.isThisDaySelectable() { dates.append(date) }
             guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
             date = newDate
         }
         return dates
    }
    
    /// Get all Dates between starting Date to self
    func getAllDatesFrom(startingDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = startingDate
         
        while date <= self {
            if date.isThisDaySelectable() { dates.append(date) }
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
    
    // MARK: Utilis specific
    func isThisDaySelectable() -> Bool {
        if self.getDayNumberOfWeek() == 1 ||
            self.getDayNumberOfWeek() == 7 ||
            self.isHoliday(in: .italy) ||
            self < Constant.startingDateBdC ||
            self > Date() {
            return false
        }
        return true
    }
    
    func getNextSelectableDate() -> Date {
        var count = 0
        var date = self.dayAfter
        while !date.isThisDaySelectable() && count < 30 {
            date = date.dayAfter
            count += 1
        }
        return date
    }
}
