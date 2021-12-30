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
    
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
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
    }
    
    override func layoutSubviews() {
        self.containerView.layer.shadowPath = UIBezierPath(roundedRect: self.containerView.bounds, cornerRadius: 15).cgPath
    }
    
    func setup(_ vc: RankingViewController ) {
        self.rankingViewController = vc
        vc.rankingType = self.rankingType
        selectedAllDateOfTheWeek(calendarView.selectedDate ?? Date.now)
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
    
    func handleChangeRankingType(_ oldRankingType: RankingType) {
        self.rankingViewController?.daysCurrentPeriod.removeAll()
        
        switch self.rankingType {
        case .weekly:
            
            self.calendarView.hideViewWithTransition(hidden: false)
            self.monthYearDatePicker.isHidden = true
            self.yearDatePicker.isHidden = true
            self.rankingViewController?.tableView.allowsSelection = true
            self.rankingViewController?.daysCurrentPeriod = self.calendarView.selectedDates
        case .monthly:
            
            self.calendarView.isHidden = true
            self.monthYearDatePicker.hideViewWithTransition(hidden: false)
            self.yearDatePicker.isHidden = true
            self.monthYearDatePicker.date = Date()
            self.rankingViewController?.tableView.allowsSelection = false
            self.rankingViewController?.daysCurrentPeriod = self.yearDatePicker.date.getAllDateOfTheMonth()
            self.rankingViewController?.daysCurrentPeriod.removeAll(where: { $0 < Constant.startingDateBdC })
        case .yearly:
            
            self.calendarView.isHidden = true
            self.monthYearDatePicker.isHidden = true
            self.yearDatePicker.hideViewWithTransition(hidden: false)
            self.yearDatePicker.date = Date()
            self.rankingViewController?.tableView.allowsSelection = false
            self.rankingViewController?.daysCurrentPeriod = self.yearDatePicker.date.getAllDateOfTheYear()
            self.rankingViewController?.daysCurrentPeriod.removeAll(where: { $0 < Constant.startingDateBdC })
        }
        self.rankingViewController?.populateAttendance()
    }
}
