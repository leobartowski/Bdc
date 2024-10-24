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
        var weeklyAttendances: [DateComponents: Int] = [:]
        
        for attendance in self.attendances {
            if let dateString = attendance.dateString, let date = DateFormatter.basicFormatter.date(from: dateString) {
                let personCount = attendance.persons?.count ?? 0
                let weekAndYear = date.getWeekNumberAndYearForWeekOfYearNumber()
                let weekKey = DateComponents(weekOfYear: weekAndYear.w, yearForWeekOfYear: weekAndYear.y)
                weeklyAttendances[weekKey, default: 0] += personCount
            }
        }
        // Sort weeks and prepare dataset
        let sortedWeeks = weeklyAttendances.keys.sorted {
            if $0.yearForWeekOfYear! != $1.yearForWeekOfYear! {
                return $0.yearForWeekOfYear! < $1.yearForWeekOfYear!
            } else {
                return $0.weekOfYear! < $1.weekOfYear!
            }
        }
        
        let personsCountForWeek = sortedWeeks.map { weeklyAttendances[$0] ?? 0 }
        for (index, personCount) in personsCountForWeek.enumerated() {
            lineChartEntries.append(ChartDataEntry(x: Double(index), y: Double(personCount), data: sortedWeeks[index].weekRangeString()))
        }
        
        let line1 = LineChartDataSet(entries: lineChartEntries)
        setAppearanceGraph(line1: line1, sortedWeeks: sortedWeeks)
        // TODO: This Marker is needed to create the point on the highlighted point, is there a bettere mode?
        let marker = WeeklyAttendanceMarkerView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        marker.chartView = self.lineChartView
        self.lineChartView.marker = marker
    }

    func setAppearanceGraph(line1: LineChartDataSet, sortedWeeks: [DateComponents]) {
        line1.drawCirclesEnabled = false
        line1.drawFilledEnabled = true
        line1.fillAlpha = 1
        line1.mode = .cubicBezier
        line1.drawHorizontalHighlightIndicatorEnabled = false
        line1.drawVerticalHighlightIndicatorEnabled = true
        line1.highlightColor = Theme.mainColor
        line1.highlightLineWidth = 2.0
        
        let gradientColors = [Theme.white.cgColor, Theme.mainColor.cgColor] as CFArray
        let colorLocations: [CGFloat] = [0.0, 1.0]
        if let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) {
            line1.fill = LinearGradientFill(gradient: gradient, angle: 90.0)
        }
        line1.colors = [Theme.mainColor]
        let data = LineChartData(dataSet: line1)
        self.lineChartView.data = data

        // Customize X-axis labels to show week number and year
        self.lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: sortedWeeks.map { weekComponents in
            "W\(weekComponents.weekOfYear!), \(weekComponents.yearForWeekOfYear!)"
        })
        self.lineChartView.xAxis.labelPosition = .bottom
        self.lineChartView.xAxis.granularity = 30
        self.lineChartView.xAxis.labelRotationAngle = 60
        self.lineChartView.xAxis.drawGridLinesEnabled = false
        self.lineChartView.leftAxis.drawGridLinesEnabled = false
        self.lineChartView.rightAxis.drawGridLinesEnabled = false
        self.lineChartView.rightAxis.enabled = false
        self.lineChartView.setScaleEnabled(false)
        self.lineChartView.pinchZoomEnabled = false
        self.lineChartView.legend.enabled = false
    }
    
    // MARK: Methods ChartViewDelegate
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        self.lineChartView.highlightPerTapEnabled = true
        let data = entry.data as? String ?? "-"
        self.lineChartViewLabel.text = "\(data)"
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        self.lineChartViewLabel.text = ""
        self.lineChartView.highlightValue(nil)

    }
    
    func chartViewDidEndPanning(_ chartView: ChartViewBase) {
        self.lineChartViewLabel.text = ""
        self.lineChartView.highlightValue(nil)
    }
}
