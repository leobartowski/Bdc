//
//  RankingTypeTableViewCell + HandleType.swift
//  Bdc
//
//  Created by leobartowski on 29/12/21.
//

import Foundation

extension RankingTypeTableViewCell {
    
    func setupAllTimeLabel() {
        self.allTimeLabel.text = "All-Time"
        self.allTimeLabel.isHidden = true
    }
    
    func monthYearDatePickerSetup() {
        self.monthYearDatePicker.isHidden = true
        self.monthYearDatePicker.locale = Locale(identifier: "it")
        self.monthYearDatePicker.minimumDate = Constant.startingDateBdC
        self.monthYearDatePicker.maximumDate = Date.now
        self.monthYearDatePicker.addTarget(self, action: #selector(monthtYearDatePickerDateChanged(_:)), for: .valueChanged)
    }
    
    func yearDatePickerSetup() {
        self.yearDatePicker.isHidden = true
        self.yearDatePicker.locale = Locale(identifier: "it")
        self.yearDatePicker.minimumDate = Constant.startingDateBdC
        self.yearDatePicker.maximumDate = Date.now
        self.yearDatePicker.addTarget(self, action: #selector(yearDatePickerDateChanged(_:)), for: .valueChanged)
    }
    
    @objc func monthtYearDatePickerDateChanged(_ sender: Any) {
        guard let rankingVC = self.rankingViewController else { return }
        rankingVC.daysCurrentPeriod.removeAll()
        rankingVC.daysCurrentPeriod = self.monthYearDatePicker.date.getAllSelectableDatesOfTheMonth()
        rankingVC.populateAttendance()
    }
    
    @objc func yearDatePickerDateChanged(_ sender: Any) {
        guard let rankingVC = self.rankingViewController else { return }
        rankingVC.daysCurrentPeriod.removeAll()
        rankingVC.daysCurrentPeriod = self.yearDatePicker.date.getAllDateOfTheYear()
        rankingVC.populateAttendance()
    }
    
    // MARK: Handle change of type
    func handleChangeRankingType(_ oldRankingType: RankingType) {
        self.rankingViewController?.daysCurrentPeriod.removeAll()
        
        switch self.rankingType {
        case .weekly:
            
            self.calendarView.hideViewWithTransition(hidden: false)
            self.monthYearDatePicker.isHidden = true
            self.yearDatePicker.isHidden = true
            self.allTimeLabel.isHidden = true
            self.rankingViewController?.tableView.allowsSelection = true
            self.rankingViewController?.daysCurrentPeriod = self.calendarView.selectedDates
        case .monthly:
            
            self.calendarView.isHidden = true
            self.monthYearDatePicker.hideViewWithTransition(hidden: false)
            self.yearDatePicker.isHidden = true
            self.allTimeLabel.isHidden = true
            self.monthYearDatePicker.date = Date()
            self.rankingViewController?.tableView.allowsSelection = false
            self.rankingViewController?.daysCurrentPeriod = self.yearDatePicker.date.getAllSelectableDatesOfTheMonth()
            self.rankingViewController?.daysCurrentPeriod.removeAll(where: { $0 < Constant.startingDateBdC || $0 > Date.tomorrow })
        case .yearly:
            
            self.calendarView.isHidden = true
            self.monthYearDatePicker.isHidden = true
            self.allTimeLabel.isHidden = true
            self.yearDatePicker.hideViewWithTransition(hidden: false)
            self.yearDatePicker.date = Date()
            self.rankingViewController?.tableView.allowsSelection = false
            self.rankingViewController?.daysCurrentPeriod = self.yearDatePicker.date.getAllDateOfTheYear()
            self.rankingViewController?.daysCurrentPeriod.removeAll(where: { $0 < Constant.startingDateBdC || $0 > Date.tomorrow })
        case .allTime:
            
            self.calendarView.isHidden = true
            self.monthYearDatePicker.isHidden = true
            self.yearDatePicker.isHidden = true
            self.allTimeLabel.hideViewWithTransition(hidden: false)
            self.rankingViewController?.tableView.allowsSelection = false
            self.rankingViewController?.daysCurrentPeriod = Date().getAllDatesFrom(startingDate: Constant.startingDateBdC)
            
        }
        self.rankingViewController?.populateAttendance()
    }
}
