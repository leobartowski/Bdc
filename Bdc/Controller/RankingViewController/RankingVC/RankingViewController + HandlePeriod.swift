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
        self.setUpContainerPeriodView()
        self.calendarSetup()
        self.monthYearDatePickerSetup()
        self.yearDatePickerSetup()
        self.setupObserver()
        self.allTimeLabel.isHidden = true
    }
    
    func setUpContainerPeriodView() {
        let cornerRadius: CGFloat = 15
        self.containerPeriodView.cornerRadius = cornerRadius
        self.containerPeriodView.layer.masksToBounds = true
    }
    
    func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.systemTimeChanged), name: UIApplication.significantTimeChangeNotification, object: nil)
    }
    
    @objc func systemTimeChanged() {
        self.updateCalendarIfNeeded()
    }
    
    // MARK: Handle Period Change
    func monthYearDatePickerSetup() {
        self.monthYearDatePicker.isHidden = true
        self.monthYearDatePicker.locale = Locale(identifier: "it")
        self.monthYearDatePicker.minimumDate = Constant.startingDateBdC
        self.monthYearDatePicker.maximumDate = Constant.endingDateBdC
//        self.monthYearDatePicker.maximumDate = Date.now
        self.monthYearDatePicker.addTarget(self, action: #selector(self.monthtYearDatePickerDateChanged(_:)), for: .valueChanged)
    }
    
    func yearDatePickerSetup() {
        self.yearDatePicker.isHidden = true
        self.yearDatePicker.locale = Locale(identifier: "it")
        self.yearDatePicker.minimumDate = Constant.startingDateBdC
        self.yearDatePicker.maximumDate = Constant.endingDateBdC
//        self.yearDatePicker.maximumDate = Date.now
        self.yearDatePicker.addTarget(self, action: #selector(self.yearDatePickerDateChanged(_:)), for: .valueChanged)
    }
    
    @objc func monthtYearDatePickerDateChanged(_ sender: Any) {
        let oldDaysCurrentPeriod = self.daysCurrentPeriod
        let newDatesCurrentPeriod = self.monthYearDatePicker.date.getAllSelectableDatesOfMonth()
        if newDatesCurrentPeriod != oldDaysCurrentPeriod {
            self.daysCurrentPeriod.removeAll()
            self.daysCurrentPeriod = newDatesCurrentPeriod
            self.populateAttendance()
        }
        
    }
    
    @objc func yearDatePickerDateChanged(_ sender: Any) {
        let oldDaysCurrentPeriod = self.daysCurrentPeriod
        let newDatesCurrentPeriod = self.yearDatePicker.date.getAllSelectableDateOfTheYear()
        if newDatesCurrentPeriod != oldDaysCurrentPeriod {
            self.daysCurrentPeriod.removeAll()
            self.daysCurrentPeriod = newDatesCurrentPeriod
            self.populateAttendance()
        }
    }
    
    // MARK: Handle change of type
    func handleChangeRankingType() {
        self.showLoader()
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
            self.daysCurrentPeriod = self.yearDatePicker.date.getAllSelectableDatesOfMonth()
            self.daysCurrentPeriod.removeAll(where: { $0 < Constant.startingDateBdC || $0 > Date.tomorrow })
        case .yearly:
            self.calendarView.isHidden = true
            self.monthYearDatePicker.isHidden = true
            self.allTimeLabel.isHidden = true
            self.yearDatePicker.hideViewWithTransition(hidden: false)
            self.yearDatePicker.date = Date()
            self.tableView.allowsSelection = false
            self.daysCurrentPeriod = self.yearDatePicker.date.getAllSelectableDateOfTheYear()
            self.daysCurrentPeriod.removeAll(where: { $0 < Constant.startingDateBdC || $0 > Date.tomorrow })
        case .allTime:
            self.calendarView.isHidden = true
            self.monthYearDatePicker.isHidden = true
            self.yearDatePicker.isHidden = true
            self.allTimeLabel.text = "All-Time"
            self.allTimeLabel.hideViewWithTransition(hidden: false)
            self.tableView.allowsSelection = false
            self.daysCurrentPeriod = Date().getAllDatesFrom(startingDate: Constant.startingDateBdC)
        case .allTimePonderate:
            self.calendarView.isHidden = true
            self.monthYearDatePicker.isHidden = true
            self.yearDatePicker.isHidden = true
            self.allTimeLabel.text = "All-Time ponderate"
            self.allTimeLabel.hideViewWithTransition(hidden: false)
            self.tableView.allowsSelection = false
            self.daysCurrentPeriod = Date().getAllDatesFrom(startingDate: Constant.startingDateBdC)
        }
        if self.rankingType != .monthly && self.rankingType != .yearly {
            self.populateAttendance()
        }
    }

}
