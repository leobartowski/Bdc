//
//  RankingViewController + HandleSlot.swift
//  Bdc
//
//  Created by leobartowski on 03/11/22.
//

import Foundation
import UIKit

extension RankingViewController {
    
    func setupSlotView() {
        self.setupContainerSlotView()
        self.setupSlotLabel()
    }
    
    func setupContainerSlotView() {
        let cornerRadius: CGFloat = 8
        self.containerSlotView.cornerRadius = cornerRadius
        self.containerSlotView.layer.masksToBounds = true
    }
    
    func setupSlotLabel() {
        switch self.slotType {
        case .morningAndEvening:
            self.slotLabel.text = "Mattina & Pomeriggio"
        case .morning:
            self.slotLabel.text = "Mattina"
        case .evening:
            self.slotLabel.text = "Pomeriggio"
        }
    }
}
