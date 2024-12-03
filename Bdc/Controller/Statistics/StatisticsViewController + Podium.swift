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
        if self.statsData.bestPals.count >= 2 {
            self.createImageViewPodium()
            self.createLabelsPodium()
        }
    }
    
    fileprivate func createImageViewPodium() {
        self.podiumFirstImageView.image = UIImage(named: CoreDataService.shared.getPersonIconString(for: self.statsData.bestPals[0].key))
        self.podiumSecondImageView.image = UIImage(named: CoreDataService.shared.getPersonIconString(for: self.statsData.bestPals[1].key))
        self.podiumThirdImageView.image = UIImage(named: CoreDataService.shared.getPersonIconString(for: self.statsData.bestPals[2].key))
    }
    
    fileprivate func createLabelsPodium() {
        self.podiumFirstLabel.text = "\(self.statsData.bestPals[0].value)"
        self.podiumSecondLabel.text = "\(self.statsData.bestPals[1].value)"
        self.podiumThirdLabel.text = "\(self.statsData.bestPals[2].value)"
    }
    
}
