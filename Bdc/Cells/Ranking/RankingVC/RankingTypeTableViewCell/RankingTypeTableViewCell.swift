//
//  RankingTypeTableViewCell.swift
//  Bdc
//
//  Created by leobartowski on 29/12/21.
//

import UIKit
import FSCalendar

class RankingTypeTableViewCell: UITableViewCell {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var calendarView: FSCalendar!
    @IBOutlet var monthYearDatePicker: MonthYearPickerView!
    @IBOutlet var yearDatePicker: YearPickerView!
    @IBOutlet var allTimeLabel: UILabel!
    // Constraints
    @IBOutlet var calendarHeightConstraint: NSLayoutConstraint!
    
    var rankingType: RankingType = .weekly
    
    weak var rankingViewController: RankingViewController?
    
    override func awakeFromNib() {
        // Shadow container View
        self.setupShadowContainerView()
        // Calendar Setup
        self.calendarSetup()
        // Month and Year Date Picker
        self.monthYearDatePickerSetup()
        // Year Date Picker
        self.yearDatePickerSetup()
        // Setup Label
        self.setupAllTimeLabel()
        // Setup Observer
        self.setupObserver()
    }
    
    override func layoutSubviews() {
        self.containerView.layer.shadowPath = UIBezierPath(roundedRect: self.containerView.bounds, cornerRadius: 15).cgPath
    }
    
    func setup(_ vc: RankingViewController ) {
        self.rankingViewController = vc
        vc.rankingType = self.rankingType
        self.selectedAllDateOfTheWeek(calendarView.selectedDate ?? Date.now)
    }
    
    func setupShadowContainerView() {
        let cornerRadius: CGFloat = 15
        self.containerView.cornerRadius = cornerRadius
        self.containerView.layer.masksToBounds = true
        self.containerView.layer.shadowColor = UIColor.gray.cgColor
        self.containerView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.containerView.layer.shadowOpacity = 0.3
        self.containerView.layer.shadowRadius = 2
        self.containerView.layer.shadowPath = UIBezierPath(roundedRect: self.containerView.bounds, cornerRadius: cornerRadius).cgPath
        self.containerView.layer.masksToBounds = false
    }
    
    func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.systemTimeChanged), name: UIApplication.significantTimeChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didChangeWeightedAttendance(_:)), name: .didChangeweightedAttendance, object: nil)
    }
    
    @objc func systemTimeChanged() {
        self.updateCalendarIfNeeded()
    }
    
    @objc func didChangeWeightedAttendance(_: Notification) {
        let isWeightedAttendance = UserDefaults.standard.bool(forKey: "weightedAttendance")
        self.allTimeLabel.text = isWeightedAttendance ? "All-Time ponderate" : "All-Time"
    }
}
