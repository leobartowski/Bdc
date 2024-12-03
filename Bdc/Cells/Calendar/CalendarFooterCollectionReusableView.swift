//
//  CalendarHeaderCollectionReusableView.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 19/11/21.
//

import Foundation
import UIKit

class CalendarFooterCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var label: UILabel!
    
    override class func awakeFromNib() {
    }
    
    override func prepareForReuse() {
    }
    
    func updateLabel(_ attCount: Int? = 0, _ admonishCount: Int? = 0) {
        self.label.text = "presenti: \(attCount!), ammoniti: \(admonishCount!)"
    }
}
