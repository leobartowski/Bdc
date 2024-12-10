//
//  StatisticsViewController + Podium.swift
//  Bdc
//
//  Created by leobartowski on 03/12/24.
//

import UIKit
import IncrementableLabel

extension StatisticsViewController {
    
    func createPodium() {
        if self.statsData.bestPals.count > 2 {
            self.createImageViewPodium()
            self.createLabelsPodium()
        }
    }
    
    fileprivate func createImageViewPodium() {
        self.podiumFirstImageView.image = UIImage(named: CommonUtility.getProfileImageString(CoreDataService.shared.getPerson(for: self.statsData.bestPals[0].key)))
        self.podiumSecondImageView.image = UIImage(named: CommonUtility.getProfileImageString(CoreDataService.shared.getPerson(for: self.statsData.bestPals[1].key)))
        self.podiumThirdImageView.image = UIImage(named: CommonUtility.getProfileImageString(CoreDataService.shared.getPerson(for: self.statsData.bestPals[2].key)))
    }
    
    fileprivate func createLabelsPodium() {
        if self.statsData.totalAttendance != 0 {
            let percentage0 = Double(self.statsData.bestPals[0].value) / Double(self.statsData.totalAttendance) * 100
            let percentage1 = Double(self.statsData.bestPals[1].value) / Double(self.statsData.totalAttendance) * 100
            let percentage2 = Double(self.statsData.bestPals[2].value) / Double(self.statsData.totalAttendance) * 100
            self.podiumFirstLabel.text = "\(self.statsData.bestPals[0].value) - \(String(format: "%.0f", percentage0))%"
            self.podiumSecondLabel.text = "\(self.statsData.bestPals[1].value) - \(String(format: "%.0f", percentage1))%"
            self.podiumThirdLabel.text = "\(self.statsData.bestPals[2].value) - \(String(format: "%.0f", percentage2))%"
        }
    }
}
