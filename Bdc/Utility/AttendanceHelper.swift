//
//  AttendanceHelper.swift
//  Bdc
//
//  Created by leobartowski on 31/10/24.
//
import Foundation

class AttendanceHelper {
    
    let total: [Attendance]
    
    init(total: [Attendance]) {
        self.total = total
    }
    
    func getAttendance(ofWeeksAgo weeksOffset: Int) -> [Attendance] {
        let offset = weeksOffset > 0 ? weeksOffset * -1 : weeksOffset
        let dates = Date().getAllSelectableDatesOfWeek(weeksOffset: offset)
        let datesString = dates.map { DateFormatter.basicFormatter.string(from: $0) }
        return self.total.filter { att in
            return datesString.contains(att.dateString ?? "")
        }
    }
    
    func getAttendance(ofMonthsAgo monthsOffset: Int) -> [Attendance] {
        let offset = monthsOffset > 0 ? monthsOffset * -1 : monthsOffset
        let dates = Date().getAllSelectableDatesOfMonth(ofMonthsAgo: offset)
        let datesString = dates.map { DateFormatter.basicFormatter.string(from: $0) }
        return self.total.filter { att in
            return datesString.contains(att.dateString ?? "")
        }
    }
    
    func getAttendance(ofYearsAgo yearsOffset: Int) -> [Attendance] {
        let offset = yearsOffset > 0 ? yearsOffset * -1 : yearsOffset
        let dates = Date().getAllSelectableDateOfTheYear(ofYearsAgo: offset)
        let datesString = dates.map { DateFormatter.basicFormatter.string(from: $0) }
        return self.total.filter { att in
            return datesString.contains(att.dateString ?? "")
        }
    }
}
