//
//  RankingSingleDayCollectionViewCell.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 28/11/21.
//

import UIKit

class RankingSingleDayCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainLabel: UILabel!
    
    override func awakeFromNib() {
        self.mainLabel.textColor = .lightGray
        self.mainLabel.font = .systemFont(ofSize: 17, weight: .light)
    }
    
    func setupIfPresent() {
        
        self.mainLabel.textColor = .black
        self.mainLabel.font = .systemFont(ofSize: 17, weight: .bold)
    }
    
    
}
