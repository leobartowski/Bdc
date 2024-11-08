//
//  dda.swift
//  Bdc
//
//  Created by leobartowski on 29/10/24.
//

import Foundation
import DGCharts

extension StatisticsViewController {
    
    func setUpLineChartDataSetAppearance(_ lineDS: LineChartDataSet) {
        lineDS.drawCirclesEnabled = false
        lineDS.drawValuesEnabled = false
        lineDS.drawFilledEnabled = true
        lineDS.mode = .cubicBezier
        lineDS.fillAlpha = 1
        lineDS.lineWidth = 1.0
        lineDS.drawHorizontalHighlightIndicatorEnabled = false
        lineDS.drawVerticalHighlightIndicatorEnabled = true
        lineDS.highlightColor = UIColor.systemGray4
        lineDS.highlightLineWidth = 1.0
        let gradientColors = [Theme.white.cgColor, Theme.mainColor.cgColor] as CFArray
        let colorLocations: [CGFloat] = [0.0, 1.0]
        if let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) {
            lineDS.fill = LinearGradientFill(gradient: gradient, angle: 90.0)
        }
        lineDS.colors = [Theme.mainColor]
    }
    
    func setUpSlotLineChartDataSetAppearance(_ lineDS: LineChartDataSet, isMorning: Bool) {
        lineDS.drawCirclesEnabled = false
        lineDS.drawValuesEnabled = false
        lineDS.lineWidth = 1
        lineDS.mode = .cubicBezier
        lineDS.drawHorizontalHighlightIndicatorEnabled = false
        lineDS.drawVerticalHighlightIndicatorEnabled = true
        lineDS.highlightColor = UIColor.systemGray4
        lineDS.highlightLineWidth = 1.0
        lineDS.colors = isMorning ? [Theme.morningLineColor] : [Theme.eveningLineColor]
    }
    
    func setUpLineChart() {
        self.lineChartView.delegate = self
        self.lineChartView.highlightPerTapEnabled = false
        self.lineChartView.highlightPerDragEnabled = false
        self.lineChartView.leftAxis.drawAxisLineEnabled = false
        self.lineChartView.leftAxis.drawGridLinesEnabled = false
        self.lineChartView.leftAxis.granularity = 30
        self.lineChartView.rightAxis.drawGridLinesEnabled = false
        self.lineChartView.rightAxis.enabled = false
        self.lineChartView.xAxis.drawAxisLineEnabled = false
        self.lineChartView.xAxis.labelPosition = .bottom
        self.lineChartView.xAxis.drawGridLinesEnabled = false
        self.lineChartView.xAxis.labelTextColor = UIColor.label
        self.lineChartView.leftAxis.labelTextColor = UIColor.label
        self.lineChartView.setScaleEnabled(false)
        self.lineChartView.pinchZoomEnabled = false
        self.lineChartView.legend.enabled = false
        let marker = LinearMarkerViewForPoint()
        marker.chartView = self.lineChartView
        self.lineChartView.marker = marker
    }
    
    func setUpSlotLineChart() {
        self.slotLineChartView.delegate = self
        self.slotLineChartView.highlightPerTapEnabled = false
        self.slotLineChartView.highlightPerDragEnabled = false
        self.slotLineChartView.leftAxis.drawAxisLineEnabled = false
        self.slotLineChartView.leftAxis.drawGridLinesEnabled = false
        self.slotLineChartView.leftAxis.granularity = 15
        self.slotLineChartView.rightAxis.drawGridLinesEnabled = false
        self.slotLineChartView.rightAxis.enabled = false
        self.slotLineChartView.xAxis.drawAxisLineEnabled = false
        self.slotLineChartView.xAxis.labelPosition = .bottom
        self.slotLineChartView.xAxis.drawGridLinesEnabled = false
        self.slotLineChartView.xAxis.labelTextColor = UIColor.label
        self.slotLineChartView.leftAxis.labelTextColor = UIColor.label
        self.slotLineChartView.setScaleEnabled(false)
        self.slotLineChartView.pinchZoomEnabled = false
        self.slotLineChartView.legend.enabled = false
        let marker = LinearMarkerViewForDoublePoint()
        marker.chartView = self.slotLineChartView
        self.slotLineChartView.marker = marker
    }
}
