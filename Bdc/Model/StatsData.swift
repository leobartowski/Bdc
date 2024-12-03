//
//  StatsData.swift
//  Bdc
//
//  Created by leobartowski on 31/10/24.
//
import Foundation

class StatsData {
    
    var attHelper: AttendanceHelper
    let personIfIndividual: Person?
    let isIndividual: Bool
    var totalAttendance: Int = 0
    var totalAttendanceMorning: Int = 0
    var totalAttendanceEvening: Int = 0
    var weeklyGrowth: Double = 0
    var monthlyGrowth: Double = 0
    var yearlyGrowth: Double = 0
    var maxDay: (dateString: String, nOfAtt: Int) = ("", 0)
    var firstDateIndividual: String = ""
    var bestStreak: (beginDate: String, endDate: String, count: Int) = ("", "", 0)
    var bestPals: [Dictionary<String, Int>.Element] = []
    
    init(_ totalAttendance: [Attendance], _ person: Person? = nil) {
        self.personIfIndividual = person
        self.isIndividual = person != nil
        self.attHelper = AttendanceHelper(total: totalAttendance)
    }
    
    func calculateAllStats() {
        self.totalAttendance = self.calculateNumberOfAttendance(self.attHelper.total)
        self.totalAttendanceMorning = self.calculateNumberOfAttendanceMorning(self.attHelper.total)
        self.totalAttendanceEvening = self.totalAttendance - self.totalAttendanceMorning
        self.weeklyGrowth = self.calculateWeeklyGrowth()
        self.monthlyGrowth = self.calculateMonthlyGrowth()
        self.yearlyGrowth = self.calculateYearlyGrowth()
        let firstMaxBestPals = self.getFirstMaxDayAndBestPals()
        self.maxDay = (firstMaxBestPals.maxDateString, firstMaxBestPals.maxCount)
        if isIndividual {
            self.firstDateIndividual = firstMaxBestPals.firstDayString
            self.bestStreak =  self.getBestStreakIndividual()
            self.bestPals = firstMaxBestPals.bestPals
        }
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
        return records.reduce(into: 0) { $0 += (isIndividual ? 1 : $1.persons?.count ?? 0) }
    }
    
    private func calculateNumberOfAttendanceMorning(_ records: [Attendance]) -> Int {
        return records
            .filter { $0.type == DayType.morning.rawValue }
            .reduce(into: 0) { $0 += (isIndividual ? 1 : $1.persons?.count ?? 0) }
    }
    
    private func getFirstMaxDayAndBestPals() -> (maxDateString: String, maxCount: Int, firstDayString: String, bestPals: [Dictionary<String, Int>.Element]) {
        var allAttendances: [String: Int] = [:]
        var countAttedancesPal: [String: Int] = [:]
        var currentMin = Date()
        for attendance in self.attHelper.total {
            if let dateString = attendance.dateString {
                let personCount = isIndividual ? 1 : attendance.persons?.count ?? 0
                if self.isIndividual {
                    let persons = attendance.persons?.allObjects as? [Person] ?? []
                    for pal in persons where pal.name != self.personIfIndividual?.name {
                        countAttedancesPal[pal.name ?? "", default: 0] += 1
                    }
                }
                allAttendances[dateString, default: 0] += personCount
                if self.isIndividual && personCount == 1 {
                    let date = DateFormatter.basicFormatter.date(from: dateString) ?? Date()
                    if currentMin > date { currentMin = date }
                }
            }
        }
        let bestPalsSorted = countAttedancesPal.sorted { $0.value > $1.value }
        let firstDayString = DateFormatter.basicFormatter.string(from: currentMin)
        if let maxDay = allAttendances.max(by: {$0.value < $1.value}) {
            return (maxDay.key, maxDay.value, firstDayString, bestPalsSorted)
        }
        return ("", 0, firstDayString, bestPalsSorted)
    }
    
    private func getBestStreakIndividual() -> (beginDate: String, endDate: String, count: Int) {
        let sortedAttendanceDates = Set(
            self.attHelper.total.compactMap { DateFormatter.basicFormatter.date(from: $0.dateString ?? "")
            }).sorted()
        var bestStreak = 0, currentStreak = 1
        var bestStreakStartDate: Date?, bestStreakEndDate: Date?, currentStreakStartDate: Date?, currentStreakEndDate: Date?
        
        for i in 0..<sortedAttendanceDates.count - 1 {
            let currentDate = sortedAttendanceDates[i]
            let nextDate = sortedAttendanceDates[i + 1]
            if Calendar.current.isDate(nextDate, inSameDayAs: currentDate.getNextSelectableDate()) {
                currentStreak += 1
                currentStreakEndDate = nextDate
                if currentStreakStartDate == nil { currentStreakStartDate = currentDate }
            } else {
                currentStreak = 1
                currentStreakStartDate = nil
                currentStreakEndDate = nil
            }
            if currentStreak >= bestStreak {
                bestStreak = currentStreak
                bestStreakStartDate = currentStreakStartDate ?? currentDate
                bestStreakEndDate = currentStreakEndDate ?? currentDate
            }
        }
        let beginDate = bestStreakStartDate != nil ? DateFormatter.basicFormatter.string(from: bestStreakStartDate!) : ""
        let endDate = bestStreakEndDate != nil ? DateFormatter.basicFormatter.string(from: bestStreakEndDate!) : ""
        return (beginDate, endDate, bestStreak)
    }
}
