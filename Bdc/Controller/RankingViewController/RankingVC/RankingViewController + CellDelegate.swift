//
//  RankingViewController + CellDelegate.swift
//  Bdc
//
//  Created by leobartowski on 09/11/24.
//
import Foundation

extension RankingViewController: RankingWeeklyTableViewCellDelegate, RankingTableViewCellDelegate {
    
    func cell(_ cell: RankingTableViewCell, didSelectNameLabelAt indexPath: IndexPath) {
        self.openStatisticsVC(indexPath)
    }
    
    func cell(_ cell: RankingWeeklyTableViewCell, didSelectNameLabelAt indexPath: IndexPath) {
        self.openStatisticsVC(indexPath)
    }
    
    fileprivate func openStatisticsVC(_ indexPath: IndexPath) {
        self.feedbackGenerator.impactOccurred(intensity: 0.7)
        if let vc = self.getViewController(fromStoryboard: "Statistics", withIdentifier: "statisticsId") as? StatisticsViewController {
            vc.person = self.rankingPersonsAttendaces[indexPath.row].person
            self.present(vc, animated: true)
        }
    }
}
