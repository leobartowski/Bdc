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
}