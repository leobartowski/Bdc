//
//  CalendarHeaderCollectionReusableView.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 19/11/21.
//

import Foundation
import UIKit

class CalendarHeaderCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func prepareForReuse() {
        
    }
    
    override func awakeFromNib() {
        self.searchBar.setValue("Annulla", forKey: "cancelButtonText")

    }
}
