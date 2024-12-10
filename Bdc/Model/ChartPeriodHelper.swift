//
//  ChartPeriod.swift
//  Bdc
//
//  Created by leobartowski on 29/10/24.
//
import Foundation

public enum ChartPeriodType {
    case weekly
    case monthly
    case yearly
}

public struct ChartPeriodHelper {
    
    var chartPeriodType: ChartPeriodType
    
    public init(_ chartPeriodType: ChartPeriodType) {
        self.chartPeriodType = chartPeriodType
    }
    
    /// Generates the appropriate `DateComponents` key for each period type.
    public func dateComponents(for date: Date) -> DateComponents {
        switch self.chartPeriodType {
        case .weekly:
            let weekAndYear = date.getWeekNumberAndYearForWeekOfYearNumber()
            return DateComponents(weekOfYear: weekAndYear.w, yearForWeekOfYear: weekAndYear.y)
        case .monthly:
            let monthAndYear = date.getMonthAndYearNumber()
            return DateComponents(year: monthAndYear.y, month: monthAndYear.m)
        case .yearly:
            return DateComponents(year: date.getYearNumber())
        }
    }
    
    public func isCurrentPeriodOver(date: Date) -> Bool {
        switch self.chartPeriodType {
        case .weekly:
            let dayNumber = date.getDayNumberOfWeek()
            return dayNumber == 1 || dayNumber == 7
        case .monthly:
            let endOfMonth = date.getEndOfMonth()
            return date.getDayNumber() == endOfMonth.getDayNumber()
        case .yearly:
            return date.getYearNumber() != Date().getYearNumber()
        }
    }
    
    func getStats(with statsData: StatsData) -> Double {
        switch self.chartPeriodType {
        case .weekly:
            return statsData.weeklyGrowth
        case .monthly:
            return statsData.monthlyGrowth
        case .yearly:
            return statsData.yearlyGrowth
        }
    }
    
    func getMaxNumbersOfAttandanceIndividual() -> Double {
        switch self.chartPeriodType {
        case .weekly:
            return Constant.maxAttWeeklyIndividual
        case .monthly:
            return Constant.maxAttMonthlyIndividual
        case .yearly:
            return Constant.maxAttYearlyIndividual
        }
    }
    
    func getMaxNumbersOfSlotAttandanceIndividual() -> Double {
        switch self.chartPeriodType {
        case .weekly:
            return Constant.maxAttWeeklySlotIndividual
        case .monthly:
            return Constant.maxAttMonthlySlotIndividual
        case .yearly:
            return Constant.maxAttYearlySlotIndividual
        }
    }
    
    /// Generates all keys (as `DateComponents`) starting from a specific date until today.
    func generateAllKeys() -> [DateComponents] {
        var keys: [DateComponents] = []
        let calendar = Calendar.current
        let today = Date()
        var currentDate = Constant.startingDateBdC
        
        switch self.chartPeriodType {
        case .weekly:
            while currentDate <= today {
                let weekComponents = dateComponents(for: currentDate)
                keys.append(weekComponents)
                currentDate = calendar.date(byAdding: .weekOfYear, value: 1, to: currentDate) ?? today
            }
        case .monthly:
            currentDate = currentDate.getStartOfMonth()
            while currentDate <= today {
                let monthComponents = dateComponents(for: currentDate)
                keys.append(monthComponents)
                currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate) ?? today
            }
        case .yearly:
            currentDate = currentDate.getStartOfYear()
            while currentDate <= today {
                let yearComponents = dateComponents(for: currentDate)
                keys.append(yearComponents)
                currentDate = calendar.date(byAdding: .year, value: 1, to: currentDate) ?? today
            }
        }
        return keys
    }
    
    /// Sorts keys based on the period type.
    public func sortKeys(_ keys: [DateComponents]) -> [DateComponents] {
        // swiftlint:disable identifier_name
        return keys.sorted { (x, y) -> Bool in
            switch self.chartPeriodType {
            case .weekly:
                if (x.yearForWeekOfYear ?? 0) != (y.yearForWeekOfYear ?? 0) {
                    return (x.yearForWeekOfYear ?? 0) < (y.yearForWeekOfYear ?? 0)
                } else {
                    return (x.weekOfYear ?? 0) < (y.weekOfYear ?? 0)
                }
            case .monthly:
                if (x.year ?? 0) != (y.year ?? 0) {
                    return (x.year ?? 0) < (y.year ?? 0)
                } else {
                    return (x.month ?? 0) < (y.month ?? 0)
                }
                
            case .yearly:
                return (x.year ?? 0) < (y.year ?? 0)
            }
        }
        // swiftlint:enable identifier_name
    }
    
    /// Creates a label for chart entries based on the period type.
    public func label(for dateComponent: DateComponents) -> String {
        switch self.chartPeriodType {
        case .weekly:
            return StringChartUtility.getStringForWeeklyChartLabel(from: dateComponent)
        case .monthly:
            return StringChartUtility.getStringForMonthlyChartLabel(from: dateComponent)
        case .yearly:
            return "Presenze del \(dateComponent.year ?? 0): "
        }
    }
    
    public func labelsForGrowrth(_ isGrowthPositive: Bool) -> (start: String, end: String) {
        let text = isGrowthPositive ? "aumentate" : "diminuite"
        switch self.chartPeriodType {
        case .weekly:
            return ("Le presenze della scorsa settimana sono \(text) del ", " rispetto a due settimane fa")
        case .monthly:
            return ("Le presenze del mese scorso sono \(text) del ", " rispetto a due mesi fa")
        case .yearly:
            return ("Le presenze dell'anno scorso scorso sono \(text) del ", " rispetto a due anni fa")
        }
    }
}
