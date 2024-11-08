//
//  j.swift
//  Bdc
//
//  Created by leobartowski on 29/10/24.
//
import Foundation
import DGCharts

extension StatisticsViewController {
    
    func setUpRecognizer() {
        let longPressGestureLineChart = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressOnLineChart(_:)))
        longPressGestureLineChart.minimumPressDuration = 0.1
        self.lineChartView.addGestureRecognizer(longPressGestureLineChart)
        let longPressGestureSlotLineChart = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressOnLineChart(_:)))
        longPressGestureSlotLineChart.minimumPressDuration = 0.1
        self.slotLineChartView.addGestureRecognizer(longPressGestureSlotLineChart)
        let longPressGestureBarChart = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressOnBarChart(_:)))
        longPressGestureBarChart.minimumPressDuration = 0.05
        self.barChartView.addGestureRecognizer(longPressGestureBarChart)
        for recognizer in self.lineChartView.gestureRecognizers ?? [] {
            recognizer.delegate = self
        }
        for recognizer in self.slotLineChartView.gestureRecognizers ?? [] {
            recognizer.delegate = self
        }
        for recognizer in self.barChartView.gestureRecognizers ?? [] {
            recognizer.delegate = self
        }
    }
    
    @objc func handleLongPressOnLineChart(_ gesture: UILongPressGestureRecognizer) {
        guard let chartView = gesture.view as? ChartViewBase else { return }
        let location = gesture.location(in: chartView)
        switch gesture.state {
        case .began:
            self.feedbackGenerator.impactOccurred(intensity: 0.7)
            if let highlight = chartView.getHighlightByTouchPoint(location) {
                chartView.highlightValue(highlight, callDelegate: true)
            }
        case .changed:
//            self.feedbackGenerator.impactOccurred(intensity: 0.2)
            if let highlight = chartView.getHighlightByTouchPoint(location) {
                chartView.highlightValue(highlight, callDelegate: true)
            }
        case .ended:
            if chartView == self.lineChartView {
                self.lineChartViewLabel.text = ""
                self.lineChartView.highlightValue(nil)
            } else if chartView == self.slotLineChartView {
                self.slotLineChartViewLabel.text = ""
                self.slotLineChartView.highlightValue(nil)
            }
        default:
            break
        }
    }
    
    @objc func handleLongPressOnBarChart(_ gesture: UILongPressGestureRecognizer) {
        guard let chartView = self.barChartView else { return }
        let location = gesture.location(in: chartView)
        switch gesture.state {
        case .began:
            self.feedbackGenerator.impactOccurred(intensity: 0.7)
            if let newHighlight = chartView.getHighlightByTouchPoint(location) {
                if newHighlight == chartView.highlighted.first {
                    chartView.highlightValue(nil)
                } else {
                    chartView.highlightValue(newHighlight, callDelegate: true)
                }
            }
        default:
            break
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let chartView = gestureRecognizer.view as? ChartViewBase else { return true }
        if chartView.highlighter != nil {
            return false
        }
        return true
    }
    
    // MARK: Methods ChartViewDelegate
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        if chartView == self.lineChartView {
            let data = entry.data as? String ?? "-"
            self.lineChartlabelHandler.setLabelTextForLineChart(self.lineChartViewLabel, with: data, lastWord: String(Int(entry.y)))
        } else if chartView == self.slotLineChartView {
            if highlight.dataSetIndex == 0 {
                self.morningCountForSlotChart = Int(entry.y)
                self.eveningCountForSlotChart = Int(chartView.data?.dataSet(at: 1)?.entriesForXValue(highlight.x).first?.y ?? 0)
            }
            if highlight.dataSetIndex == 1 {
                self.eveningCountForSlotChart = Int(entry.y)
                self.morningCountForSlotChart = Int(chartView.data?.dataSet(at: 0)?.entriesForXValue(highlight.x).first?.y ?? 0)
            }
            let dateString = entry.data as? String ?? "-"
            self.lineChartlabelHandler.setLabelTextForSlotLineChart(self.slotLineChartViewLabel,
                                                                    baseText: dateString,
                                                                    numberOfMorning: self.morningCountForSlotChart,
                                                                    numberOfAfternoon: self.eveningCountForSlotChart)
        }
    }
}
