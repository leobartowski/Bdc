//
//  RankingViewController+ConfettiView.swift
//  Bdc
//
//  Created by leobartowski on 06/06/22.
//

import Foundation
import SwiftConfettiView
import UIKit

extension RankingViewController {
    
    
    func calculateIfShowConfetti(_ rankingAttendace: RankingPersonAttendance) -> Bool {
        guard let lastDayCurrentPeriod = self.daysCurrentPeriod.last else { return false }
        switch self.rankingType {
        case .weekly:
            // TODO: Improve this logic
            return (rankingAttendace.possibleAttendanceNumber == rankingAttendace.attendanceNumber) && self.checkIfCurrentWeekAndIfSoPastFriday(lastDayCurrentPeriod)
            
        case .monthly:
            return (rankingAttendace.possibleAttendanceNumber == rankingAttendace.attendanceNumber) && (lastDayCurrentPeriod.getMonthAndYearNumber() != Date().getMonthAndYearNumber())
        default: return false
        }
    }
    
    private func checkIfCurrentWeekAndIfSoPastFriday(_ dateToCheck: Date) -> Bool {
        // Show confetti if the week is not the current
        if dateToCheck.getWeekNumberAndYearNumber() != Date().getWeekNumberAndYearNumber() {
            return true
            // Show confetti if the week is the current and is saturday or sunday
        } else if dateToCheck.getDayNumberOfWeek() == 1 || dateToCheck.getDayNumberOfWeek() == 7 {
            return true
        }
        return false
    }
    
    
    
    func setupConfettiView() {
        self.confettiView = SwiftConfettiView(frame: self.view.bounds)
        self.confettiView?.intensity = 0.5
        self.confettiView?.isUserInteractionEnabled = false
        self.view.addSubview(self.confettiView ?? UIView())
    }
    
    func startConfetti() {
        if !(self.confettiView?.isActive() ?? true) {
            self.confettiView?.startConfetti()
        }
    }
}
