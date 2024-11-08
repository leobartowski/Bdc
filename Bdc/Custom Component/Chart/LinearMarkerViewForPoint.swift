//
//  WeeklyAttendanceMarkerView.swift
//  Bdc
//
//  Created by leobartowski on 24/10/24.
//

import DGCharts

class LinearMarkerViewForPoint: MarkerView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(context: CGContext, point: CGPoint) {
        super.draw(context: context, point: point)
        context.setFillColor(Theme.avatarRed.cgColor)
        context.addArc(center: point, radius: 6.0, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        context.fillPath()
        
        context.setStrokeColor(Theme.black.cgColor)
        context.setLineWidth(2.0) // Change to desired border width
        context.addArc(center: point, radius: 6.0, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        context.strokePath()
    }
}
