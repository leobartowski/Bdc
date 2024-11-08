//
//  djdj.swift
//  Bdc
//
//  Created by leobartowski on 25/10/24.
//
import DGCharts

class MonthYearXAxisFormatter: IndexAxisValueFormatter {
    
    private let sortedWeeks: [DateComponents]
    
    init(sortedWeeks: [DateComponents]) {
        self.sortedWeeks = sortedWeeks
        super.init()
    }
    
    override func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        // Safeguard to ensure we don't go out of bounds
        guard Int(value) < self.sortedWeeks.count, Int(value) >= 0 else { return "" }
        let weekComponent = self.sortedWeeks[Int(value)]
        if let date = Calendar.itBasic.date(from: weekComponent) {
            return DateFormatter.monthAndYearVerboseFormatter.string(from: date)
        }
        return ""
    }
}
