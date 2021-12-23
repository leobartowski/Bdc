//
//  RankingViewController+DatePicker.swift
//  Bdc
//
//  Created by leobartowski on 23/12/21.
//

import Foundation
import UIKit

extension RankingViewController {
    
    func datePickerSetup() {
        self.datePicker.locale = Locale(identifier: "it")
        self.datePicker.minimumDate = DateFormatter.basicFormatter.date(from: "25/10/2021") ?? Date()
        self.datePicker.maximumDate = Date.now
        self.datePicker.addTarget(self, action: #selector(pickerDateChanged(_:)), for: .valueChanged)
    }
    
    @objc func pickerDateChanged(_ sender: UIPickerView) {
        print("date changed: \(self.datePicker.date)")
    }
    
}
