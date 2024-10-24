//
//  DateComponents - Ext.swift
//  Bdc
//
//  Created by leobartowski on 24/10/24.
//
import UIKit

extension DateComponents {
    
    func weekRangeString() -> String {
        let calendar = Calendar.itBasic
        if let startOfWeek = calendar.date(from: self) {
            let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: startOfWeek)
            guard let firstDay = calendar.date(from: components) else { return "" }
            guard let lastDay = calendar.date(byAdding: .day, value: 6, to: firstDay) else { return "" }
            let firstDayString = DateFormatter.dayAndMonthFormatter.string(from: firstDay)
            let lastDayString = DateFormatter.dayAndMonthFormatter.string(from: lastDay)
            let yearString = DateFormatter.verboseYear.string(from: firstDay)
            return "dal \(firstDayString) al \(lastDayString) del \(yearString)"
        }
        return ""
    }
}
