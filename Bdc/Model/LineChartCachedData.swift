//
//  LineChartData.swift
//  Bdc
//
//  Created by leobartowski on 25/10/24.
//
import DGCharts

public class LineChartCachedData {
    
    public var lineChartDS: LineChartDataSet
    public var sortedData: [Dictionary<DateComponents, Int>.Keys.Element] = []
    public var lineChartMorningDS: LineChartDataSet
    public var sortedMorningData: [Dictionary<DateComponents, Int>.Keys.Element] = []
    public var lineChartEveningDS: LineChartDataSet
    public var sortedEveningData: [Dictionary<DateComponents, Int>.Keys.Element] = []
    
    init(_ lineChartDS: LineChartDataSet,
         _ sortedData: [Dictionary<DateComponents, Int>.Keys.Element],
         _ lineChartMorningDS: LineChartDataSet,
         _ sortedMorningData: [Dictionary<DateComponents, Int>.Keys.Element],
         _ lineChartEveningDS: LineChartDataSet,
         _ sortedEveningData: [Dictionary<DateComponents, Int>.Keys.Element]) {
        
        self.lineChartDS = lineChartDS
        self.sortedData = sortedData
        
        self.lineChartMorningDS = lineChartMorningDS
        self.sortedMorningData = sortedMorningData
        
        self.lineChartEveningDS = lineChartEveningDS
        self.sortedEveningData = sortedEveningData
        
    }
}
