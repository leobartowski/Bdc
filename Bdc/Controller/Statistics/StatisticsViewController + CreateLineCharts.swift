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
        if self.isIndividualStats {
            self.lineChartView.leftAxis.axisMaximum = self.chartPeriodHelper.getMaxNumbersOfAttandanceIndividual()
            self.slotLineChartView.leftAxis.axisMaximum = self.chartPeriodHelper.getMaxNumbersOfSlotAttandanceIndividual()
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
    
    func createMonthlyLineCharts() {
        if self.monthlyChartData == nil {
            self.monthlyChartData = self.createChartCachedData(for: ChartPeriodType.monthly, attendances: self.attendances)
            self.setUpLineChartDataSetAppearance(self.monthlyChartData!.lineChartDS)
            self.setUpSlotLineChartDataSetAppearance(self.monthlyChartData!.lineChartMorningDS, isMorning: true)
            self.setUpSlotLineChartDataSetAppearance(self.monthlyChartData!.lineChartEveningDS, isMorning: false)
        }
        if self.isIndividualStats {
            self.lineChartView.leftAxis.axisMaximum = self.chartPeriodHelper.getMaxNumbersOfAttandanceIndividual()
            self.slotLineChartView.leftAxis.axisMaximum = self.chartPeriodHelper.getMaxNumbersOfSlotAttandanceIndividual()
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
    
    func createYearlyLineCharts() {
        if self.yearlyChartData == nil {
            self.yearlyChartData = self.createChartCachedData(for: ChartPeriodType.yearly, attendances: self.attendances)
            self.setUpLineChartDataSetAppearance(self.yearlyChartData!.lineChartDS)
            self.setUpSlotLineChartDataSetAppearance(self.yearlyChartData!.lineChartMorningDS, isMorning: true)
            self.setUpSlotLineChartDataSetAppearance(self.yearlyChartData!.lineChartEveningDS, isMorning: false)
        }
        if self.isIndividualStats {
            self.lineChartView.leftAxis.axisMaximum = self.chartPeriodHelper.getMaxNumbersOfAttandanceIndividual()
            self.slotLineChartView.leftAxis.axisMaximum = self.chartPeriodHelper.getMaxNumbersOfSlotAttandanceIndividual()
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
    
    private func createChartCachedData(for chartPeriodType: ChartPeriodType, attendances: [Attendance]) -> LineChartCachedData {
        var allAttendances: [DateComponents: Int] = [:]
        var morningAttendances: [DateComponents: Int] = [:]
        var eveningAttendances: [DateComponents: Int] = [:]
        for key in self.chartPeriodHelper.generateAllKeys() {
            allAttendances[key] = 0
            morningAttendances[key] = 0
            eveningAttendances[key] = 0
        }
        for attendance in attendances {
            if let dateString = attendance.dateString, let date = DateFormatter.basicFormatter.date(from: dateString) {
                let key = self.chartPeriodHelper.dateComponents(for: date)
                let personCount = self.isIndividualStats ? 1 : attendance.persons?.count ?? 0
                if attendance.type == DayType.morning.rawValue {
                    morningAttendances[key, default: 0] += personCount
                } else {
                    eveningAttendances[key, default: 0] += personCount
                }
                allAttendances[key, default: 0] += personCount
            }
        }
        var sortedKeys = self.chartPeriodHelper.sortKeys(Array(allAttendances.keys))
        var sortedMorningKeys = self.chartPeriodHelper.sortKeys(Array(morningAttendances.keys))
        var sortedEveningKeys = self.chartPeriodHelper.sortKeys(Array(eveningAttendances.keys))
        // Remove all keys current period if it's not over
        if !self.showCurrentPeriodInCharts, let dateComponents = sortedKeys.last, let date = Calendar.itBasic.date(from: dateComponents) {
            if !self.chartPeriodHelper.isCurrentPeriodOver(date: date) {
                sortedKeys.removeLast()
                sortedMorningKeys.removeLast()
                sortedEveningKeys.removeLast()
            }
        }
        let allEntries = createChartDataEntries(from: sortedKeys, with: allAttendances, labelProvider: self.chartPeriodHelper.label)
        let morningEntries = createChartDataEntries(from: sortedMorningKeys, with: morningAttendances, labelProvider: self.chartPeriodHelper.label)
        let eveningEntries = createChartDataEntries(from: sortedEveningKeys, with: eveningAttendances, labelProvider: self.chartPeriodHelper.label)
        
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
            entry.data = labelProvider(key) as AnyObject
            return entry
        }
    }
}
