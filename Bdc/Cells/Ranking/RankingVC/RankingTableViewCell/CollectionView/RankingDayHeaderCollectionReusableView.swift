//
//  RankingDayHeaderCollectionReusableView.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 28/11/21.
//

import Foundation
import UIKit

class RankingDayHeaderCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet var titleLabel: UILabel!

    override func awakeFromNib() {
        self.titleLabel.textColor = Theme.avatarBlack
    }
}
