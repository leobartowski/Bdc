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
        self.setupShadowContainerSlotView()
        self.setupSlotLabel()
    }
    
    func setupShadowContainerSlotView() {

        
        let cornerRadius: CGFloat = 8
        self.containerSlotView.cornerRadius = cornerRadius
        self.containerSlotView.layer.masksToBounds = true
        self.containerSlotView.layer.shadowColor = UIColor.gray.cgColor
        self.containerSlotView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.containerSlotView.layer.shadowOpacity = 0.3
        self.containerSlotView.layer.shadowRadius = 2
        self.containerSlotView.layer.shadowPath = UIBezierPath(roundedRect: self.containerSlotView.bounds, cornerRadius: cornerRadius).cgPath
        self.containerSlotView.layer.masksToBounds = false
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
