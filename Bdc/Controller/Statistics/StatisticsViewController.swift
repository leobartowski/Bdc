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
    
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var personNameLabel: UILabel!
    @IBOutlet weak var personDescriptionLabel: UILabel!
    @IBOutlet weak var barGraphCell: UITableViewCell!
    @IBOutlet weak var segmentedControl: MySegmentedControl!
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var slotLineChartView: LineChartView!
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var lineChartViewLabel: UILabel!
    @IBOutlet weak var slotLineChartViewLabel: UILabel!
    @IBOutlet weak var totalAttendanceLabel: IncrementableLabel!
    @IBOutlet weak var periodGrowthLabel: IncrementableLabel!
    @IBOutlet weak var secondStatsLabel: IncrementableLabel!
    @IBOutlet weak var firstLabelsCellContainerView: UIView!
    @IBOutlet weak var periodGrowthLabelCellContainerView: UIView!
    @IBOutlet weak var ratioMorningEveningCellContainerView: UIView!
    @IBOutlet weak var thirdPalLabel: UILabel!
    @IBOutlet weak var secondPalLabel: UILabel!
    @IBOutlet weak var firstPalLabel: UILabel!
    @IBOutlet weak var bestPalsCellContainerView: UIView!
    @IBOutlet weak var dividerBarChartLabel: UILabel!
    @IBOutlet weak var dividerSlotLineChartLabel: UILabel!
    @IBOutlet weak var dividerLineChartLabel: UILabel!
    @IBOutlet weak var ratioMorningEveningLabel: IncrementableLabel!
    // Podium
    @IBOutlet weak var podiumFirstImageView: UIImageView!
    @IBOutlet weak var podiumSecondImageView: UIImageView!
    @IBOutlet weak var podiumThirdImageView: UIImageView!
    @IBOutlet weak var podiumFirstLabel: UILabel!
    @IBOutlet weak var podiumSecondLabel: UILabel!
    @IBOutlet weak var podiumThirdLabel: UILabel!
    
    var person: Person?
    var isIndividualStats = false
    var hasViewAppearedOnce = false
    
    var attendances: [Attendance] = []
    var weeklyChartData: LineChartCachedData?
    var monthlyChartData: LineChartCachedData?
    var yearlyChartData: LineChartCachedData?
    var weeklyBarChartData: BarChartCachedData?
    var monthlyBarChartData: BarChartCachedData?
    var morningCountForSlotChart: Int = 0
    var eveningCountForSlotChart: Int = 0
    var chartPeriodType: ChartPeriodType = .monthly
    var chartPeriodHelper = ChartPeriodHelper(.monthly)
    var statsData =  StatsData([])
    var lineChartlabelHandler = EfficientLabelHandler()
    let incrementaLabelAnimationDuration: Double = 1.5
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    override func viewDidLoad() {
        self.isIndividualStats = self.person != nil
        self.attendances = self.getAttendance() ?? []
        self.statsData = StatsData(self.attendances, self.person)
        self.statsData.calculateAllStats()
        self.setUpForIndividualStats()
        self.setUpFirstLabelsCellContainerView()
        self.setUpPeriodGrowthCellContainerView()
        self.setUpRatioMorningEveningContainerView()
        self.setUpBestPalsContainerView()
        self.setUpSegmentedControl()
        self.setUpLineChart()
        self.setUpSlotLineChart()
        self.setupBarChartView()
        self.createMonthlyLineCharts()
        self.createMonthlyAttendanceBarChart()
        self.setUpRecognizer()
        self.setTextDividerLabels()
        self.createLabels()
        self.createPodium()
        self.tableView.reloadData()
        if #available(iOS 17.0, *) { self.handleTraitChange() }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !self.hasViewAppearedOnce {
            self.animateIncrementalLabels()
            self.createAndAnimateGrowthLabel()
            self.hasViewAppearedOnce = true
        }
    }
    
    private func getAttendance() -> [Attendance]? {
        return self.isIndividualStats
        ? CoreDataService.shared.getAllAttendaces(for: self.person!)
        : CoreDataService.shared.getAllAttendaces()
    }
    
    func setUpForIndividualStats() {
        if let person = self.person {
            self.personImageView.layer.cornerRadius = self.personImageView.frame.height / 2
            let imageString = CommonUtility.getProfileImageString(person)
            self.personImageView.image = UIImage(named: imageString)
            self.personNameLabel.text = person.name
            self.personDescriptionLabel.text = "Prima presenza: " + self.statsData.firstDateIndividual
        }
    }
    
    func setUpFirstLabelsCellContainerView() {
        let cornerRadius: CGFloat = 15
        self.firstLabelsCellContainerView.cornerRadius = cornerRadius
        self.firstLabelsCellContainerView.layer.masksToBounds = true
    }
    
    func setUpPeriodGrowthCellContainerView() {
        let cornerRadius: CGFloat = 15
        self.periodGrowthLabelCellContainerView.cornerRadius = cornerRadius
        self.periodGrowthLabelCellContainerView.layer.masksToBounds = true

    }
    
    func setUpRatioMorningEveningContainerView() {
        let cornerRadius: CGFloat = 15
        self.ratioMorningEveningCellContainerView.cornerRadius = cornerRadius
        self.ratioMorningEveningCellContainerView.layer.masksToBounds = true
    }
    func setUpBestPalsContainerView() {
        let cornerRadius: CGFloat = 15
        self.bestPalsCellContainerView.cornerRadius = cornerRadius
        self.bestPalsCellContainerView.layer.masksToBounds = true
    }
        
    @available(iOS 17.0, *)
    func handleTraitChange() {
        self.registerForTraitChanges([UITraitUserInterfaceStyle.self], handler: { (self: Self, previousTraitCollection: UITraitCollection) in
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
    func setUpSegmentedControl() {
        self.segmentedControl.backgroundColor = Theme.contentBackground
        self.segmentedControl.borderColor = Theme.main
        self.segmentedControl.selectedSegmentTintColor = Theme.main
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: Theme.neutral]
        self.segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        
        let titleTextAttributes1 = [NSAttributedString.Key.foregroundColor: Theme.label]
        self.segmentedControl.setTitleTextAttributes(titleTextAttributes1, for: .normal)
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: Any) {
        switch self.segmentedControl.selectedSegmentIndex {
        case 0:
            self.chartPeriodType = .weekly
            self.chartPeriodHelper.chartPeriodType = .weekly
            self.createWeeklyLineCharts()
            self.createWeeklyAttendanceBarChart()
        case 1:
            self.chartPeriodType = .monthly
            self.chartPeriodHelper.chartPeriodType = .monthly
            self.createMonthlyLineCharts()
            self.createMonthlyAttendanceBarChart()
        case 2:
            self.chartPeriodHelper.chartPeriodType = .yearly
            self.chartPeriodType = .yearly
            self.createYearlyLineCharts()
        default: break
        }
        self.createAndAnimateGrowthLabel()
        self.setTextDividerLabels()
        self.tableView.reloadData()
    }
}
