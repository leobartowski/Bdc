//
//  Untitled.swift
//  Bdc
//
//  Created by leobartowski on 23/10/24.
//
import UIKit
import DGCharts

class StatisticsViewController: UITableViewController, ChartViewDelegate {
    
    @IBOutlet weak var segmentedControl: MySegmentedControl!
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var lineChartViewLabel: UILabel!
    
    var attendances: [Attendance] = []
    
    override func viewDidLoad() {
        self.lineChartView.delegate = self
        self.attendances = CoreDataService.shared.getAllAttendaces() ?? []
        self.createWeeklyChart()
    }

}
