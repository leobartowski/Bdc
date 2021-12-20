//
//  CalendarHeaderCollectionReusableView.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 19/11/21.
//

import Foundation
import UIKit

class CalendarHeaderCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet var titleLabel: UILabel!

    override func awakeFromNib() {
        titleLabel.textColor = Theme.avatarBlack
    }
}
