//
//  WeeklyAttendanceMarkerView.swift
//  Bdc
//
//  Created by leobartowski on 24/10/24.
//

import DGCharts

class WeeklyAttendanceMarkerView: MarkerView {
    
    private var label: UILabel!
    
    // Custom initializer to handle the layout of the marker
    override init(frame: CGRect) {
        super.init(frame: frame)
        label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = .boldSystemFont(ofSize: 15)
        label.textColor = Theme.mainColor
        addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Called when the marker is set to a certain entry in the chart
    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        
        let attendance = Int(entry.y)
        self.label.text = "\(attendance)"
        self.label.sizeToFit()
        super.refreshContent(entry: entry, highlight: highlight)
    }
    
    override func draw(context: CGContext, point: CGPoint) {
        // Draw the default marker background
        super.draw(context: context, point: point)
        // Position the label just above the highlighted point
        let labelWidth = label.intrinsicContentSize.width
        let labelHeight = label.intrinsicContentSize.height
        // Update label frame to center it above the point
        label.frame = CGRect(origin: point, size: CGSize(width: 50, height: 50))
        label.layer.render(in: context)
        // Draw a custom point at the selected location
        context.setFillColor(Theme.mainColor.cgColor)
        context.addArc(center: point, radius: 4.0, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        context.fillPath()


    }
}
