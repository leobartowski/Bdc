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
            return (rankingAttendace.possibleAttendanceNumber == rankingAttendace.attendanceNumber) && (lastDayCurrentPeriod.getWeekNumber() != Date().getWeekNumber())

        case .monthly:
            return (rankingAttendace.possibleAttendanceNumber == rankingAttendace.attendanceNumber) && (lastDayCurrentPeriod.getMonthAndYearNumber() != Date().getMonthAndYearNumber())
        default: return false
        }
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
