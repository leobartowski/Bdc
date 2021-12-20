//
//  RankingSingleDayCollectionViewCell.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 28/11/21.
//

import UIKit

class RankingSingleDayCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var mainLabel: UILabel!

    func setup(_ isPresent: Bool) {
        if isPresent {
            mainLabel.textColor = .black
            mainLabel.font = .systemFont(ofSize: 17, weight: .bold)
        } else {
            mainLabel.textColor = .lightGray
            mainLabel.font = .systemFont(ofSize: 17, weight: .light)
        }
    }
}
