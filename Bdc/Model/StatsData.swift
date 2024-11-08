//
//  StatsData.swift
//  Bdc
//
//  Created by leobartowski on 31/10/24.
//
import Foundation

class StatsData {
    
    var attHelper: AttendanceHelper
    var totalAttendance: Int = 0
    var totalAttendanceMorning: Int = 0
    var totalAttendanceEvening: Int = 0
    var weeklyGrowth: Double = 0
    var monthlyGrowth: Double = 0
    var yearlyGrowth: Double = 0
    var maxDay: (dateString: String, nOfAtt: Int) = ("", 0)
    
    init(_ totalAttendance: [Attendance]) {
        self.attHelper = AttendanceHelper(total: totalAttendance)
    }
    
    func calculateAllStats() {
        self.totalAttendance = self.calculateNumberOfAttendance(self.attHelper.total)
        self.totalAttendanceMorning = self.calculateNumberOfAttendanceMorning(self.attHelper.total)
        self.totalAttendanceEvening = self.totalAttendance - self.totalAttendanceMorning
        self.weeklyGrowth = self.calculateWeeklyGrowth()
        self.monthlyGrowth = self.calculateMonthlyGrowth()
        self.yearlyGrowth = self.calculateYearlyGrowth()
        self.maxDay = self.getDayandCountMaxNumberOfAttendance()
    }
    
    private func calculateWeeklyGrowth() -> Double {
        let lastWeek = attHelper.getAttendance(ofWeeksAgo: 1)
        let twoWeekAgo = attHelper.getAttendance(ofWeeksAgo: 2)
        return self.calculateAttendanceGrowth(between: lastWeek, and: twoWeekAgo)
    }
    
    private func calculateMonthlyGrowth() -> Double {
        let lastMonth = attHelper.getAttendance(ofMonthsAgo: 1)
        let twoMonthAgo = attHelper.getAttendance(ofMonthsAgo: 2)
        return self.calculateAttendanceGrowth(between: lastMonth, and: twoMonthAgo)
    }
    
    private func calculateYearlyGrowth() -> Double {
        let lastYear = attHelper.getAttendance(ofYearsAgo: 1)
        let twoYearAgo = attHelper.getAttendance(ofYearsAgo: 2)
        return self.calculateAttendanceGrowth(between: lastYear, and: twoYearAgo)
    }
    
    // MARK: Helpers Func
    private func calculateAttendanceGrowth(between period: [Attendance], and referencePeriod: [Attendance]) -> Double {
        let attPeriod = self.calculateNumberOfAttendance(period)
        let attReference = self.calculateNumberOfAttendance(referencePeriod)
        guard attReference > 0 else { return 0 }
        return ((Double(attPeriod) - Double(attReference)) / Double(attReference)) * 100
    }
    
    private func calculateNumberOfAttendance(_ records: [Attendance]) -> Int {
        return records.reduce(into: 0) { $0 += ($1.persons?.count ?? 0) }
    }
    
    private func calculateNumberOfAttendanceMorning(_ records: [Attendance]) -> Int {
        return records
            .filter { $0.type == DayType.morning.rawValue }
            .reduce(into: 0) { $0 += ($1.persons?.count ?? 0) }
    }
    
    
    private func getDayandCountMaxNumberOfAttendance() -> (dateString: String, nOfAtt: Int) {
        var allAttendances: [String: Int] = [:]
        for attendance in self.attHelper.total {
            if let dateString = attendance.dateString {
                let personCount = attendance.persons?.count ?? 0
                allAttendances[dateString, default: 0] += personCount
            }
        }
        if let maxDay = allAttendances.max(by: {$0.value < $1.value}) {
            return (maxDay.key, maxDay.value)
        }
        return ("", 0)
    }
    
}
