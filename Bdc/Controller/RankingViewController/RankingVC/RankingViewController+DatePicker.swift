//
//  RankingViewController+DatePicker.swift
//  Bdc
//
//  Created by leobartowski on 23/12/21.
//

import Foundation
import UIKit

extension RankingViewController {
    
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
        self.daysCurrentPeriod.removeAll()
        self.daysCurrentPeriod = self.monthYearDatePicker.date.getAllDateOfTheMonth()
        self.populateAttendance()
    }
    
    @objc func yearDatePickerDateChanged(_ sender: Any) {
        self.daysCurrentPeriod.removeAll()
        self.daysCurrentPeriod = self.yearDatePicker.date.getAllDateOfTheYear()
        self.populateAttendance()
    }
    
}
