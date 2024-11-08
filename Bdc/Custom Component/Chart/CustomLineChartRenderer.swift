//
//  hjsdhfsdj.swift
//  Bdc
//
//  Created by leobartowski on 24/10/24.
//

import DGCharts

class CustomLineChartRenderer: LineChartRenderer {
    
    draw
    
    override func drawHighlighted(context: CGContext, indices: [Highlight]) {
        guard let dataProvider = self.dataProvider else { return }
        let lineData = dataProvider.lineData

        for high in indices {
            guard let set = lineData?.getDataSetForEntry(high.dataSetIndex) as? LineChartDataSet else {
                continue
            }

            if !set.isHighlightEnabled {
                continue
            }

            // Get the entry for the highlighted x-value
            guard let entry = set.entryForXValue(high.x, closestToY: high.y) else { continue }

            context.saveGState()

            // Get the pixel coordinates of the selected point
            let highlightPoint = self.trans?.pixelForValues(x: entry.x, y: entry.y)
            if let point = highlightPoint {
                // Draw outer circle (border)
                let borderColor = UIColor.red.cgColor
                context.setStrokeColor(borderColor)
                context.setLineWidth(4.0) // Set the width of the border
                context.strokeEllipse(in: CGRect(x: point.x - 8, y: point.y - 8, width: 16, height: 16))

                // Draw inner circle (the point itself)
                let innerCircleColor = UIColor.white.cgColor
                context.setFillColor(innerCircleColor)
                context.fillEllipse(in: CGRect(x: point.x - 6, y: point.y - 6, width: 12, height: 12))
            }

            context.restoreGState()
        }
    }
}
