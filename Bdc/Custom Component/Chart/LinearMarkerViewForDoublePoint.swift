//
//  WeeklyAttendanceMarkerView.swift
//  Bdc
//
//  Created by leobartowski on 24/10/24.
//

import DGCharts

class LinearMarkerViewForDoublePoint: MarkerView {
    
    private var xValue: Double = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        self.xValue = highlight.x
        super.refreshContent(entry: entry, highlight: highlight)
    }
    
    override func draw(context: CGContext, point: CGPoint) {
        super.draw(context: context, point: point)
        
        guard let chartView = self.chartView as? LineChartView, let data = chartView.data else { return }
        for i in 0..<data.dataSetCount {
            if let dataSet = data.dataSets[i] as? LineChartDataSet,
               let yEntry = dataSet.entriesForXValue(self.xValue).first {
                let yPosition = chartView.getTransformer(forAxis: dataSet.axisDependency).pixelForValues(x: yEntry.x, y: yEntry.y).y
                context.setFillColor(dataSet.colors.first?.cgColor ?? UIColor.black.cgColor)
//                context.setFillColor(Theme.avatarRed.cgColor)
                context.addArc(center: CGPoint(x: point.x, y: yPosition), radius: 6.0, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
                context.fillPath()
                
                context.setStrokeColor(Theme.black.cgColor)
                context.setLineWidth(2.0) // Change to desired border width
                context.addArc(center: CGPoint(x: point.x, y: yPosition), radius: 6.0, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
                context.strokePath()
            }
        }
    }

}
