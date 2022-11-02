//
//  RankingSlotTypeTableViewCell.swift
//  Bdc
//
//  Created by leobartowski on 30/08/22.
//

import Foundation
import UIKit

class RankingSlotTypeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet var containerView: UIView!
    
    var slotType: SlotType = .morningAndEvening
    
    override func awakeFromNib() {
        self.setupShadowContainerView()
    }
    
    override func layoutSubviews() {
        self.containerView.layer.shadowPath = UIBezierPath(roundedRect: self.containerView.bounds, cornerRadius: 8).cgPath
    }
    
    func setupShadowContainerView() {
        let cornerRadius: CGFloat = 8
        self.containerView.cornerRadius = cornerRadius
        self.containerView.layer.masksToBounds = true
        self.containerView.layer.shadowColor = UIColor.gray.cgColor
        self.containerView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.containerView.layer.shadowOpacity = 0.3
        self.containerView.layer.shadowRadius = 2
        self.containerView.layer.shadowPath = UIBezierPath(roundedRect: self.containerView.bounds, cornerRadius: cornerRadius).cgPath
        self.containerView.layer.masksToBounds = false
    }
    
    func setup(_ slotType: SlotType) {
        switch slotType {
        case .morningAndEvening:
            self.mainLabel.text = "Mattina & Pomeriggio"
        case .morning:
            self.mainLabel.text = "Mattina"
        case .evening:
            self.mainLabel.text = "Pomeriggio"
        }
    }
}
