//
//  StatisticsViewController + Chart.swift
//  Bdc
//
//  Created by leobartowski on 23/10/24.
//

import DGCharts

extension StatisticsViewController {
    
    func createWeeklyLineCharts() {
        if self.weeklyChartData == nil {
            self.weeklyChartData = self.createChartCachedData(for: ChartPeriodType.weekly, attendances: self.attendances)
            self.setUpLineChartDataSetAppearance(self.weeklyChartData!.lineChartDS)
            self.setUpSlotLineChartDataSetAppearance(self.weeklyChartData!.lineChartMorningDS, isMorning: true)
            self.setUpSlotLineChartDataSetAppearance(self.weeklyChartData!.lineChartEveningDS, isMorning: false)
        }
        self.lineChartView.xAxis.granularity = 10
        self.lineChartView.xAxis.avoidFirstLastClippingEnabled = false
        self.lineChartView.xAxis.valueFormatter = MonthYearXAxisFormatter(sortedWeeks: self.weeklyChartData?.sortedData ?? [])
        self.lineChartView.data = LineChartData(dataSet: self.weeklyChartData!.lineChartDS)
        self.lineChartView.notifyDataSetChanged()
        
        self.slotLineChartView.xAxis.granularity = 10
        self.slotLineChartView.xAxis.avoidFirstLastClippingEnabled = false
        self.slotLineChartView.xAxis.valueFormatter = MonthYearXAxisFormatter(sortedWeeks: self.weeklyChartData?.sortedData ?? [])
        
        let dataSets: [ChartDataSetProtocol] = [self.weeklyChartData!.lineChartMorningDS, self.weeklyChartData!.lineChartEveningDS]
        let lineData = LineChartData(dataSets: dataSets)
        self.slotLineChartView.data = lineData
        self.slotLineChartView.notifyDataSetChanged()
        
    }
    
    func createMonthlyChart() {
        if self.monthlyChartData == nil {
            self.monthlyChartData = self.createChartCachedData(for: ChartPeriodType.monthly, attendances: self.attendances)
            self.setUpLineChartDataSetAppearance(self.monthlyChartData!.lineChartDS)
            self.setUpSlotLineChartDataSetAppearance(self.monthlyChartData!.lineChartMorningDS, isMorning: true)
            self.setUpSlotLineChartDataSetAppearance(self.monthlyChartData!.lineChartEveningDS, isMorning: false)
        }
        self.lineChartView.xAxis.granularity = 5
        self.lineChartView.xAxis.avoidFirstLastClippingEnabled = false
        self.lineChartView.xAxis.valueFormatter = MonthYearXAxisFormatter(sortedWeeks: self.monthlyChartData!.sortedData)
        self.lineChartView.data = LineChartData(dataSet: self.monthlyChartData!.lineChartDS)
        self.lineChartView.notifyDataSetChanged()
        
        self.slotLineChartView.xAxis.granularity = 10
        self.slotLineChartView.xAxis.avoidFirstLastClippingEnabled = false
        self.slotLineChartView.xAxis.valueFormatter = MonthYearXAxisFormatter(sortedWeeks: self.monthlyChartData?.sortedData ?? [])
        
        let dataSets: [ChartDataSetProtocol] = [self.monthlyChartData!.lineChartMorningDS, self.monthlyChartData!.lineChartEveningDS]
        let lineData = LineChartData(dataSets: dataSets)
        self.slotLineChartView.data = lineData
        self.slotLineChartView.notifyDataSetChanged()
    }
    
    private func createChartCachedData(for chartPeriodType: ChartPeriodType, attendances: [Attendance]) -> LineChartCachedData {
        let period = ChartPeriodHelper(chartPeriodType)
        var allAttendances: [DateComponents: Int] = [:]
        var morningAttendances: [DateComponents: Int] = [:]
        var eveningAttendances: [DateComponents: Int] = [:]
        for key in period.generateAllKeys() {
            allAttendances[key] = 0
            morningAttendances[key] = 0
            eveningAttendances[key] = 0
        }
        for attendance in attendances {
            if let dateString = attendance.dateString, let date = DateFormatter.basicFormatter.date(from: dateString) {
                let key = period.dateComponents(for: date)
                let personCount = self.isIndividualStats ? 1 : attendance.persons?.count ?? 0
                if attendance.type == DayType.morning.rawValue {
                    morningAttendances[key, default: 0] += personCount
                } else {
                    eveningAttendances[key, default: 0] += personCount
                }
                allAttendances[key, default: 0] += personCount
            }
        }
        let sortedKeys = period.sortKeys(Array(allAttendances.keys))
        let sortedMorningKeys = period.sortKeys(Array(morningAttendances.keys))
        let sortedEveningKeys = period.sortKeys(Array(eveningAttendances.keys))
        
        let allEntries = createChartDataEntries(from: sortedKeys, with: allAttendances, labelProvider: period.label)
        let morningEntries = createChartDataEntries(from: sortedMorningKeys, with: morningAttendances, labelProvider: period.label)
        let eveningEntries = createChartDataEntries(from: sortedEveningKeys, with: eveningAttendances, labelProvider: period.label)
        
        return LineChartCachedData(LineChartDataSet(entries: allEntries),
                                   sortedKeys,
                                   LineChartDataSet(entries: morningEntries),
                                   sortedMorningKeys,
                                   LineChartDataSet(entries: eveningEntries),
                                   sortedEveningKeys)
    }
    
    private func createChartDataEntries(from keys: [DateComponents], with values: [DateComponents: Int], labelProvider: (DateComponents) -> String) -> [ChartDataEntry] {
        return keys.enumerated().compactMap { index, key in
            guard let value = values[key] else { return nil }
            let entry = ChartDataEntry(x: Double(index), y: Double(value))
            entry.data = labelProvider(key) as AnyObject // Label for x-axis
            return entry
        }
    }
    
    func createYearlyChart() {
        if self.yearlyChartData == nil {
            self.yearlyChartData = self.createChartCachedData(for: ChartPeriodType.yearly, attendances: self.attendances)
            self.setUpLineChartDataSetAppearance(self.yearlyChartData!.lineChartDS)
            self.setUpSlotLineChartDataSetAppearance(self.yearlyChartData!.lineChartMorningDS, isMorning: true)
            self.setUpSlotLineChartDataSetAppearance(self.yearlyChartData!.lineChartEveningDS, isMorning: false)
        }
        self.lineChartView.xAxis.granularity = 1
        self.lineChartView.xAxis.avoidFirstLastClippingEnabled = true
        self.lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: self.yearlyChartData!.sortedData.map { String($0.year!) })
        self.lineChartView.data = LineChartData(dataSet: self.yearlyChartData!.lineChartDS)
        self.lineChartView.notifyDataSetChanged()
        
        self.slotLineChartView.xAxis.granularity = 1
        self.slotLineChartView.xAxis.avoidFirstLastClippingEnabled = true
        self.slotLineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: self.yearlyChartData!.sortedData.map { String($0.year!) })
        
        let dataSets: [ChartDataSetProtocol] = [self.yearlyChartData!.lineChartMorningDS, self.yearlyChartData!.lineChartEveningDS]
        let lineData = LineChartData(dataSets: dataSets)
        self.slotLineChartView.data = lineData
        self.slotLineChartView.notifyDataSetChanged()
    }
}
