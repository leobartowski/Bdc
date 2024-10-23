//
//  RankingSingleDayCollectionViewCell.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 28/11/21.
//

import UIKit

class RankingSingleDayCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var mainLabel: UILabel!
    
    override func prepareForReuse() {
        self.contentView.backgroundColor = .clear
        self.mainLabel.textColor = .systemGray3
        self.mainLabel.font = .systemFont(ofSize: 17, weight: .light)
        self.mainLabel.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
    }
    
    func setupIfPresent() { // Setup for all the days not holiday
        self.mainLabel.textColor = UIColor.label
        self.mainLabel.font = .systemFont(ofSize: 17, weight: .bold)
    }
    
    func setupForHoliday() { // Setup for all the days that are holiday
        self.mainLabel.diagonalStrikeThrough(color: Theme.avatarRed.cgColor)
    }
    
    func setupIfAdmonished() { // Setup for all the days that are holiday
        
        self.mainLabel.font = .systemFont(ofSize: 17, weight: .bold)
        self.contentView.backgroundColor = Theme.customYellow
    }
}
