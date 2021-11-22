//
//  TextSpreadSheetCell.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 21/11/21.
//

import Foundation
import SpreadsheetView
import UIKit

class TextSpreadSheetCell: Cell {
    
    let label = UILabel()
    var column = Int()
    var myCornerRadius: CGFloat = 0
    
    
    override var frame: CGRect {
        didSet {
            label.frame = bounds.insetBy(dx: 10, dy: 2)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear // Needed because there is a background view beside the content view
        contentView.backgroundColor = .white
        
        label.frame = bounds
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        
        contentView.addSubview(label)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func setUp(_ column: Int, _ text: String = "") {
        self.column = column
        self.myCornerRadius = column == 2 ? 15 : 0
        self.label.text = text
        self.setUpCornerRadius()
    }
    
    func setUpCornerRadius() {
        
        contentView.layer.borderWidth = 0.2
        contentView.layer.borderColor = Theme.FSCalendarStandardSelectionColor.cgColor
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = myCornerRadius
        contentView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]

    }
}
