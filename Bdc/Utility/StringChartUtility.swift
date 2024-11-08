//
//  StringChartUtility.swift
//  Bdc
//
//  Created by leobartowski on 25/10/24.
//
import Foundation

public class StringChartUtility {
    
    static func getStringForWeeklyChartLabel(from dateComponents: DateComponents) -> String {
        let calendar = Calendar.itBasic
        if let startOfWeek = calendar.date(from: dateComponents) {
            let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: startOfWeek)
            guard let firstDay = calendar.date(from: components) else { return "" }
            guard let lastDay = calendar.date(byAdding: .day, value: 6, to: firstDay) else { return "" }
            let firstDayString = DateFormatter.dayAndMonthFormatter.string(from: firstDay)
            let lastDayString = DateFormatter.dayAndMonthFormatter.string(from: lastDay)
            let yearString = DateFormatter.verboseYear.string(from: firstDay)
            return "Presenze dal \(firstDayString) al \(lastDayString) del \(yearString): "
        }
        return ""
    }
    
    static func getStringForMonthlyChartLabel(from dateComponents: DateComponents) -> String {
        if let date = Calendar.current.date(from: dateComponents) {
            let dateString = DateFormatter.verboseMonthYear.string(from: date)
            return "Presenze di \(dateString): "
        }
        return ""
    }
}
