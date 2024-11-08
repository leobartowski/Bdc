//
//  LineChartData.swift
//  Bdc
//
//  Created by leobartowski on 25/10/24.
//
import DGCharts

public class BarChartCachedData {
    
    public var barChartDS: BarChartDataSet
    public var data: [Int] = []
    
    init(_ barChartDS: BarChartDataSet,
         _ data: [Int]) {
        
        self.barChartDS = barChartDS
        self.data = data
    }
}
