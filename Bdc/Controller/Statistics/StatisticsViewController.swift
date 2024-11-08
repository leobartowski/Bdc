//
//  Untitled.swift
//  Bdc
//
//  Created by leobartowski on 23/10/24.
//
import UIKit
import DGCharts
import IncrementableLabel

class StatisticsViewController: UITableViewController, ChartViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var barGraphCell: UITableViewCell!
    @IBOutlet weak var segmentedControl: MySegmentedControl!
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var slotLineChartView: LineChartView!
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var lineChartViewLabel: UILabel!
    @IBOutlet weak var slotLineChartViewLabel: UILabel!
    @IBOutlet weak var totalAttendanceLabel: IncrementableLabel!
    @IBOutlet weak var periodGrowthLabel: IncrementableLabel!
    @IBOutlet weak var dayMaxNumberOfAttendanceLabel: IncrementableLabel!
    @IBOutlet weak var firstLabelsCellContainerView: UIView!
    @IBOutlet weak var periodGrowthLabelCellContainerView: UIView!
    @IBOutlet weak var ratioMorningEveningCellContainerView: UIView!
    @IBOutlet weak var dividerBarChartLabel: UILabel!
    @IBOutlet weak var dividerSlotLineChartLabel: UILabel!
    @IBOutlet weak var dividerLineChartLabel: UILabel!
    @IBOutlet weak var ratioMorningEveningLabel: IncrementableLabel!
    
    var attendances: [Attendance] = []
    var weeklyChartData: LineChartCachedData?
    var monthlyChartData: LineChartCachedData?
    var yearlyChartData: LineChartCachedData?
    var weeklyBarChartData: BarChartCachedData?
    var monthlyBarChartData: BarChartCachedData?
    var morningCountForSlotChart: Int = 0
    var eveningCountForSlotChart: Int = 0
    var chartPeriodType: ChartPeriodType = .weekly
    var statsData =  StatsData([])
    
    var lineChartlabelHandler = EfficientLabelHandler()
    let incrementaLabelAnimationDuration: Double = 1.5
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    override func viewDidLoad() {
        self.attendances = CoreDataService.shared.getAllAttendaces() ?? []
        self.statsData = StatsData(self.attendances)
        self.statsData.calculateAllStats()
        self.setupShadowFirstLabelsCellContainerView()
        self.setupShadowPeriodGrowthCellContainerView()
        self.setupShadowRatioMorningEveningContainerView()
        self.setUpLineChart()
        self.setUpSlotLineChart()
        self.setupBarChartView()
        self.createWeeklyAttendanceBarChart()
        self.createWeeklyLineCharts()
        self.setupSegmentedControl()
        self.setUpRecognizer()
        self.setTextDividerLabels()
        self.createLabels()
        self.tableView.reloadData()
        if #available(iOS 17.0, *) { self.handleTraitChange() }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.animateIncrementalLabels()
        self.createAndAnimateGrowthLabel()
    }
    
    override func viewDidLayoutSubviews() {
        self.firstLabelsCellContainerView.layer.shadowPath = UIBezierPath(roundedRect: self.firstLabelsCellContainerView.bounds, cornerRadius: 15).cgPath
        self.periodGrowthLabelCellContainerView.layer.shadowPath = UIBezierPath(roundedRect: self.periodGrowthLabelCellContainerView.bounds, cornerRadius: 15).cgPath
        self.ratioMorningEveningCellContainerView.layer.shadowPath = UIBezierPath(roundedRect: self.ratioMorningEveningCellContainerView.bounds, cornerRadius: 15).cgPath
    }
    
    func setupShadowFirstLabelsCellContainerView() {
        let cornerRadius: CGFloat = 15
        self.firstLabelsCellContainerView.cornerRadius = cornerRadius
        self.firstLabelsCellContainerView.layer.masksToBounds = true
        if self.traitCollection.userInterfaceStyle != .dark {
            self.firstLabelsCellContainerView.layer.shadowColor = UIColor.systemGray.cgColor
            self.firstLabelsCellContainerView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            self.firstLabelsCellContainerView.layer.shadowOpacity = 0.3
            self.firstLabelsCellContainerView.layer.shadowRadius = 2
            self.firstLabelsCellContainerView.layer.shadowPath = UIBezierPath(roundedRect: self.firstLabelsCellContainerView.bounds, cornerRadius: cornerRadius).cgPath
            self.firstLabelsCellContainerView.layer.masksToBounds = false
        } else {
            self.firstLabelsCellContainerView.removeShadow()
        }
    }
    
    func setupShadowPeriodGrowthCellContainerView() {
        let cornerRadius: CGFloat = 15
        self.periodGrowthLabelCellContainerView.cornerRadius = cornerRadius
        self.periodGrowthLabelCellContainerView.layer.masksToBounds = true
        if self.traitCollection.userInterfaceStyle != .dark {
            self.periodGrowthLabelCellContainerView.layer.shadowColor = UIColor.systemGray.cgColor
            self.periodGrowthLabelCellContainerView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            self.periodGrowthLabelCellContainerView.layer.shadowOpacity = 0.3
            self.periodGrowthLabelCellContainerView.layer.shadowRadius = 2
            self.periodGrowthLabelCellContainerView.layer.shadowPath = UIBezierPath(roundedRect: self.periodGrowthLabelCellContainerView.bounds, cornerRadius: cornerRadius).cgPath
            self.periodGrowthLabelCellContainerView.layer.masksToBounds = false
        } else {
            self.periodGrowthLabelCellContainerView.removeShadow()
        }
    }
    
    func setupShadowRatioMorningEveningContainerView() {
        let cornerRadius: CGFloat = 15
        self.ratioMorningEveningCellContainerView.cornerRadius = cornerRadius
        self.ratioMorningEveningCellContainerView.layer.masksToBounds = true
        if self.traitCollection.userInterfaceStyle != .dark {
            self.ratioMorningEveningCellContainerView.layer.shadowColor = UIColor.systemGray.cgColor
            self.ratioMorningEveningCellContainerView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            self.ratioMorningEveningCellContainerView.layer.shadowOpacity = 0.3
            self.ratioMorningEveningCellContainerView.layer.shadowRadius = 2
            self.ratioMorningEveningCellContainerView.layer.shadowPath = UIBezierPath(roundedRect: self.ratioMorningEveningCellContainerView.bounds, cornerRadius: cornerRadius).cgPath
            self.ratioMorningEveningCellContainerView.layer.masksToBounds = false
        } else {
            self.ratioMorningEveningCellContainerView.removeShadow()
        }
    }
        
    @available(iOS 17.0, *)
    func handleTraitChange() {
        self.registerForTraitChanges([UITraitUserInterfaceStyle.self], handler: { (self: Self, previousTraitCollection: UITraitCollection) in
            self.setupShadowFirstLabelsCellContainerView()
            self.setupShadowPeriodGrowthCellContainerView()
            self.setupShadowRatioMorningEveningContainerView()
            self.setupSegmentedControl()
            self.setUpLineChart()
            self.setupBarChartView()
            if self.weeklyChartData != nil {
                self.setUpLineChartDataSetAppearance(self.weeklyChartData!.lineChartDS)
                self.setUpSlotLineChartDataSetAppearance(self.weeklyChartData!.lineChartMorningDS, isMorning: true)
                self.setUpSlotLineChartDataSetAppearance(self.weeklyChartData!.lineChartEveningDS, isMorning: false)
            }
            if self.monthlyChartData != nil {
                self.setUpLineChartDataSetAppearance(self.monthlyChartData!.lineChartDS)
                self.setUpSlotLineChartDataSetAppearance(self.monthlyChartData!.lineChartMorningDS, isMorning: true)
                self.setUpSlotLineChartDataSetAppearance(self.monthlyChartData!.lineChartEveningDS, isMorning: false)
            }
            if self.yearlyChartData != nil {
                self.setUpLineChartDataSetAppearance(self.yearlyChartData!.lineChartDS)
                self.setUpSlotLineChartDataSetAppearance(self.yearlyChartData!.lineChartMorningDS, isMorning: true)
                self.setUpSlotLineChartDataSetAppearance(self.yearlyChartData!.lineChartEveningDS, isMorning: false)
            }
            self.lineChartView.notifyDataSetChanged()
            self.slotLineChartView.notifyDataSetChanged()
            self.barChartView.notifyDataSetChanged()
        })
    }
    
    // MARK: Segmented control
    func setupSegmentedControl() {
        self.segmentedControl.backgroundColor = Theme.dirtyWhite
        if self.traitCollection.userInterfaceStyle != .dark {
            self.segmentedControl.addShadow(UIColor.systemGray3, height: 2, opacity: 0.5, shadowRadius: 1)
        } else {
            self.segmentedControl.removeShadow()
        }
        self.segmentedControl.borderColor = Theme.mainColor
        self.segmentedControl.selectedSegmentTintColor = Theme.mainColor
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: Theme.white]
        self.segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        
        let titleTextAttributes1 = [NSAttributedString.Key.foregroundColor: Theme.black]
        self.segmentedControl.setTitleTextAttributes(titleTextAttributes1, for: .normal)
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: Any) {
        switch self.segmentedControl.selectedSegmentIndex {
        case 0:
            self.chartPeriodType = .weekly
            self.createWeeklyLineCharts()
            self.createWeeklyAttendanceBarChart()
        case 1:
            self.chartPeriodType = .monthly
            self.createMonthlyChart()
            self.createMonthlyAttendanceBarChart()
        case 2:
            self.chartPeriodType = .yearly
            self.createYearlyChart()
        default: break
        }
        self.createAndAnimateGrowthLabel()
        self.setTextDividerLabels()
        self.tableView.reloadData()
    }
}
