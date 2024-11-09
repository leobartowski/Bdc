//
//  StatisticsViewController + BarChart.swift
//  Bdc
//
//  Created by leobartowski on 28/10/24.
//

import DGCharts

extension StatisticsViewController {
    
    func setupBarChartView() {
        self.barChartView.delegate = self
        self.barChartView.highlightPerTapEnabled = false
        self.barChartView.highlightPerDragEnabled = false
        self.barChartView.leftAxis.drawAxisLineEnabled = false
        self.barChartView.leftAxis.drawGridLinesEnabled = false
        self.barChartView.leftAxis.labelCount = 4
        self.barChartView.leftAxis.axisMinimum = 0.0
        self.barChartView.rightAxis.drawGridLinesEnabled = false
        self.barChartView.rightAxis.enabled = false
        self.barChartView.xAxis.drawAxisLineEnabled = false
        self.barChartView.xAxis.labelPosition = .bottom
        self.barChartView.xAxis.drawGridLinesEnabled = false
        self.barChartView.xAxis.labelTextColor = UIColor.label
        self.barChartView.leftAxis.labelTextColor = UIColor.label
        self.barChartView.setScaleEnabled(false)
        self.barChartView.pinchZoomEnabled = false
        self.barChartView.legend.enabled = false
    }
    
    func createWeeklyAttendanceBarChart() {
        if self.weeklyBarChartData == nil {
            var weekdayAttendanceCount = [Int](repeating: 0, count: 5)
            for attendance in self.attendances {
                if let dateString = attendance.dateString,
                   let date = DateFormatter.basicFormatter.date(from: dateString),
                   let dayOfWeek = Calendar.current.dateComponents([.weekday], from: date).weekday {
                    if (2...6).contains(dayOfWeek) {
                        let index = dayOfWeek - 2
                        weekdayAttendanceCount[index] += self.isIndividualStats ? 1 : attendance.persons?.count ?? 0
                    }
                }
            }
            let barChartEntries = weekdayAttendanceCount.enumerated().map { index, count in
                BarChartDataEntry(x: Double(index), y: Double(count))
            }
            let dataSet = BarChartDataSet(entries: barChartEntries)
            dataSet.colors = [Theme.mainColor]
            dataSet.drawValuesEnabled = false
            dataSet.highlightAlpha = 0.9
            dataSet.highlightColor = Theme.avatarRed
            self.weeklyBarChartData = BarChartCachedData(dataSet, weekdayAttendanceCount)
            let marker = BarChartAttendanceMarkerView(frame: CGRect(x: 0, y: 0, width: 80, height: 20))
            marker.chartView = barChartView
            self.barChartView.marker = marker
        }
        let data = BarChartData(dataSet: self.weeklyBarChartData!.barChartDS)
        data.setValueFont(.boldSystemFont(ofSize: 12))
        let weekdays = ["Lunedì", "Martedì", "Mercoledì", "Giovedì", "Venerdì"]
        self.barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: weekdays)
        self.barChartView.xAxis.labelCount = weekdays.count
        self.barChartView.data = data
    }
    
    func createMonthlyAttendanceBarChart() {
        if monthlyBarChartData == nil {
            var monthlyAttendanceCount = [Int](repeating: 0, count: 12)
            for attendance in self.attendances {
                if let dateString = attendance.dateString,
                   let date = DateFormatter.basicFormatter.date(from: dateString),
                   let month = Calendar.current.dateComponents([.month], from: date).month {
                    monthlyAttendanceCount[month - 1] += self.isIndividualStats ? 1 : attendance.persons?.count ?? 0
                }
            }
            let barChartEntries = monthlyAttendanceCount.enumerated().map { index, count in
                BarChartDataEntry(x: Double(index), y: Double(count))
            }
            let dataSet = BarChartDataSet(entries: barChartEntries)
            dataSet.colors = [Theme.mainColor]
            dataSet.drawValuesEnabled = false
            dataSet.highlightAlpha = 0.9
            dataSet.highlightColor = Theme.avatarRed
            self.monthlyBarChartData = BarChartCachedData(dataSet, monthlyAttendanceCount)
            let marker = BarChartAttendanceMarkerView(frame: CGRect(x: 0, y: 0, width: 80, height: 20))
            marker.chartView = barChartView
            self.barChartView.marker = marker
        }
        let data = BarChartData(dataSet: self.monthlyBarChartData!.barChartDS)
        data.setValueFont(.boldSystemFont(ofSize: 12))
        let monthNames = ["Gen", "Feb", "Mar", "Apr", "Mag", "Giu", "Lug", "Ago", "Set", "Ott", "Nov", "Dic"]
        self.barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: monthNames)
        self.barChartView.xAxis.labelCount = monthNames.count
        self.barChartView.data = data
    }
}
