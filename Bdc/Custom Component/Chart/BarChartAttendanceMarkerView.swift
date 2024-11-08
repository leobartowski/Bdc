//
//  dhhd.swift
//  Bdc
//
//  Created by leobartowski on 28/10/24.
//
import DGCharts

class BarChartAttendanceMarkerView: MarkerView {

    private var label: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.label = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 20))
        self.label.textAlignment = .center
        self.label.font = .boldSystemFont(ofSize: 13)
        self.label.textColor = Theme.avatarRed
        self.label.layer.cornerRadius = 5
        self.label.layer.masksToBounds = true
        addSubview(label)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // Display bar value on touch
    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        self.label.text = String(Int(entry.y))
        super.refreshContent(entry: entry, highlight: highlight)
    }

    override func offsetForDrawing(atPoint point: CGPoint) -> CGPoint {
        let size = self.frame.size
        return CGPoint(x: -size.width / 2, y: -size.height)
    }
}
