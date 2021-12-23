//
//  RankingViewController + BottomSheet.swift
//  Bdc
//
//  Created by leobartowski on 21/12/21.
//

import Foundation
import UIKit
import FittedSheets

extension RankingViewController {
    
    func presentModalToChangeRankingType() {
        
        let storyBoard = UIStoryboard(name: "BottomSheet", bundle: nil)
        if let vc = storyBoard.instantiateViewController(withIdentifier: "rankingTypeID") as? RankingTypeViewController {
            // Set starting ranking type (when first opening is always weekly)
            vc.selectedType = self.rankingType
            let sheetController = SheetViewController(
                controller: vc,
                sizes: [.fixed(310)]
            )
            sheetController.gripSize = CGSize(width: 35, height: 6)
            sheetController.didDismiss = { _ in
                // Update rankingType based on user's choice
                self.rankingType = vc.selectedType
                self.handleChangeRankingType()
            }
            self.present(sheetController, animated: true, completion: nil)
        }
    }
    
    private func handleChangeRankingType() {
        self.daysCurrentPeriod.removeAll()
        
        switch self.rankingType {
        case .weekly:
            self.calendarView.isHidden = false
            self.monthYearDatePicker.isHidden = true
            self.yearDatePicker.isHidden = true
            self.daysCurrentPeriod = self.calendarView.selectedDates
            
        case .monthly:
            self.calendarView.isHidden = true
            self.monthYearDatePicker.isHidden = false
            self.yearDatePicker.isHidden = true
            self.monthYearDatePicker.date = Date()
            self.daysCurrentPeriod = self.yearDatePicker.date.getAllDateOfTheMonth()
        case .yearly:
            
            self.calendarView.isHidden = true
            self.monthYearDatePicker.isHidden = true
            self.yearDatePicker.isHidden = false
            self.yearDatePicker.date = Date()
            self.daysCurrentPeriod = self.yearDatePicker.date.getAllDateOfTheYear()
        }
        self.populateAttendance()
    }
}
