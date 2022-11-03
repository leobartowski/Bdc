//
//  RankingViewController + Period.swift
//  Bdc
//
//  Created by leobartowski on 03/11/22.
//

import Foundation
import UIKit

extension RankingViewController {
    
     func setupHandlePeriodView() {
        // Shadow container View
        self.setupShadowContainerPeriodView()
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
    
    func setupShadowContainerPeriodView() {
        let cornerRadius: CGFloat = 15
        self.containerPeriodView.cornerRadius = cornerRadius
        self.containerPeriodView.layer.masksToBounds = true
        self.containerPeriodView.layer.shadowColor = UIColor.gray.cgColor
        self.containerPeriodView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.containerPeriodView.layer.shadowOpacity = 0.3
        self.containerPeriodView.layer.shadowRadius = 2
        self.containerPeriodView.layer.shadowPath = UIBezierPath(roundedRect: self.containerPeriodView.bounds, cornerRadius: cornerRadius).cgPath
        self.containerPeriodView.layer.masksToBounds = false
    }
    
    func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.systemTimeChanged), name: UIApplication.significantTimeChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didChangeWeightedAttendance(_:)), name: .didChangeweightedAttendance, object: nil)
    }
    
    @objc func systemTimeChanged() {
        self.updateCalendarIfNeeded()
    }
    
    // MARK: Handle Period Change
    func setupAllTimeLabel() {
        let isWeightedAttendance = UserDefaults.standard.bool(forKey: "weightedAttendance")
        self.allTimeLabel.text = isWeightedAttendance ? "All-Time ponderate" : "All-Time"
        self.allTimeLabel.isHidden = true
    }
    
    func monthYearDatePickerSetup() {
        self.monthYearDatePicker.isHidden = true
        self.monthYearDatePicker.locale = Locale(identifier: "it")
        self.monthYearDatePicker.minimumDate = Constant.startingDateBdC
        self.monthYearDatePicker.maximumDate = Date.now
        self.monthYearDatePicker.addTarget(self, action: #selector(self.monthtYearDatePickerDateChanged(_:)), for: .valueChanged)
    }
    
    func yearDatePickerSetup() {
        self.yearDatePicker.isHidden = true
        self.yearDatePicker.locale = Locale(identifier: "it")
        self.yearDatePicker.minimumDate = Constant.startingDateBdC
        self.yearDatePicker.maximumDate = Date.now
        self.yearDatePicker.addTarget(self, action: #selector(self.yearDatePickerDateChanged(_:)), for: .valueChanged)
    }
    
    @objc func monthtYearDatePickerDateChanged(_ sender: Any) {
        self.daysCurrentPeriod.removeAll()
        self.daysCurrentPeriod = self.monthYearDatePicker.date.getAllSelectableDatesOfTheMonth()
        self.populateAttendance()
    }
    
    @objc func yearDatePickerDateChanged(_ sender: Any) {
        self.daysCurrentPeriod.removeAll()
        self.daysCurrentPeriod = self.yearDatePicker.date.getAllDateOfTheYear()
        self.populateAttendance()
    }
    
    // MARK: Handle change of type
    func handleChangeRankingType(_ oldRankingType: RankingType) {
        self.daysCurrentPeriod.removeAll()
        
        switch self.rankingType {
        case .weekly:
            
            self.calendarView.hideViewWithTransition(hidden: false)
            self.monthYearDatePicker.isHidden = true
            self.yearDatePicker.isHidden = true
            self.allTimeLabel.isHidden = true
            self.tableView.allowsSelection = true
            self.daysCurrentPeriod = self.calendarView.selectedDates
        case .monthly:
            
            self.calendarView.isHidden = true
            self.monthYearDatePicker.hideViewWithTransition(hidden: false)
            self.yearDatePicker.isHidden = true
            self.allTimeLabel.isHidden = true
            self.monthYearDatePicker.date = Date()
            self.tableView.allowsSelection = false
            self.daysCurrentPeriod = self.yearDatePicker.date.getAllSelectableDatesOfTheMonth()
            self.daysCurrentPeriod.removeAll(where: { $0 < Constant.startingDateBdC || $0 > Date.tomorrow })
        case .yearly:
            
            self.calendarView.isHidden = true
            self.monthYearDatePicker.isHidden = true
            self.allTimeLabel.isHidden = true
            self.yearDatePicker.hideViewWithTransition(hidden: false)
            self.yearDatePicker.date = Date()
            self.tableView.allowsSelection = false
            self.daysCurrentPeriod = self.yearDatePicker.date.getAllDateOfTheYear()
            self.daysCurrentPeriod.removeAll(where: { $0 < Constant.startingDateBdC || $0 > Date.tomorrow })
        case .allTime:
            
            self.calendarView.isHidden = true
            self.monthYearDatePicker.isHidden = true
            self.yearDatePicker.isHidden = true
            self.allTimeLabel.hideViewWithTransition(hidden: false)
            self.tableView.allowsSelection = false
            self.daysCurrentPeriod = Date().getAllDatesFrom(startingDate: Constant.startingDateBdC)
            
        }
        self.populateAttendance()
    }
}
