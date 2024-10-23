//
//  StatisticsViewController + Chart.swift
//  Bdc
//
//  Created by leobartowski on 23/10/24.
//

import DGCharts

extension StatisticsViewController {
    
    func createWeeklyChart() {
        
        var lineChartEntries = [ChartDataEntry]()
        var weeklyAttendances: [String: Int] = [:]
        let attendeces: [Attendance] = CoreDataService.shared.getAllAttendaces() ?? []
        for attendece in attendeces {
            let personCount = attendece.persons?.count ?? 0
            let date: Date = DateFormatter.basicFormatter.date(from: attendece.dateString ?? "10/10/2020") ?? Date()
            let weekAndYear = date.getWeekNumberAndYearNumber()
            let weekKey = "Year \(weekAndYear.yearNumber) - Week \(weekAndYear.weekNumber)"
            if weeklyAttendances[weekKey] != nil {
                weeklyAttendances[weekKey]! += personCount
            } else {
                weeklyAttendances[weekKey] = personCount
            }
        }
        var count: Double = 0
        for (key, values) in weeklyAttendances {
            count += 1
            lineChartEntries.append(ChartDataEntry(x: count, y: Double(values)))
        }
        let line1 = LineChartDataSet(entries: lineChartEntries, label: "Number of Attendance Weekly")
        
        let data = LineChartData(dataSet: line1)
        self.lineChartView.data = data
        self.lineChartView.
        self.lineChartView.chartDescription.text = "My awesome chart"
    }
}
