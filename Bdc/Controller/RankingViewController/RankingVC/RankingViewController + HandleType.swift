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
            
            sheetController.shouldDismiss = { _ in
                // Update rankingType based on user's choice
                let oldRankingType = self.rankingType
                self.rankingType = vc.selectedType
                self.handleChangeRankingType(oldRankingType)
                return true
            }
            self.present(sheetController, animated: true, completion: nil)
        }
    }
    
    private func handleChangeRankingType(_ oldRankingType: RankingType) {
        self.daysCurrentPeriod.removeAll()
        
        switch self.rankingType {
        case .weekly:
            
            self.calendarView.hideViewWithTransition(hidden: false)
            self.monthYearDatePicker.isHidden = true
            self.yearDatePicker.isHidden = true
            self.tableView.allowsSelection = true
            self.daysCurrentPeriod = self.calendarView.selectedDates
        case .monthly:
            
            self.calendarView.isHidden = true
            self.monthYearDatePicker.hideViewWithTransition(hidden: false)
            self.yearDatePicker.isHidden = true
            self.monthYearDatePicker.date = Date()
            self.tableView.allowsSelection = false
            self.daysCurrentPeriod = self.yearDatePicker.date.getAllDateOfTheMonth()
            self.daysCurrentPeriod.removeAll(where: { $0 < Constant.startingDateBdC })
        case .yearly:
            
            self.calendarView.isHidden = true
            self.monthYearDatePicker.isHidden = true
            self.yearDatePicker.hideViewWithTransition(hidden: false)
            self.yearDatePicker.date = Date()
            self.tableView.allowsSelection = false
            self.daysCurrentPeriod = self.yearDatePicker.date.getAllDateOfTheYear()
            self.daysCurrentPeriod.removeAll(where: { $0 < Constant.startingDateBdC })
        }
        self.populateAttendance()
    }
}
