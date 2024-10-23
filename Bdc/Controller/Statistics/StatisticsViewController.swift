//
//  Untitled.swift
//  Bdc
//
//  Created by leobartowski on 23/10/24.
//
import UIKit
import DGCharts

class StatisticsViewController: UITableViewController {
    
    @IBOutlet weak var segmentedControl: MySegmentedControl!
    @IBOutlet weak var lineChartView: LineChartView!
    
    override func viewDidLoad() {
        self.createWeeklyChart()
    }

}
