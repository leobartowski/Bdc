//
//  CalendarHeaderCollectionReusableView.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 19/11/21.
//

import Foundation
import UIKit


class CalendarHeaderCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        
        self.titleLabel.textColor = Theme.avatarBlack
    }
}
