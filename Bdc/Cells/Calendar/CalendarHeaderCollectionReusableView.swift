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
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func awakeFromNib() {
        self.titleLabel.textColor = Theme.avatarBlack
        self.searchBar.isHidden = true
    }
}
