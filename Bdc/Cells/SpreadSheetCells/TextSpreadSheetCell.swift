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
        
        self.backgroundColor = .clear // Needed because there is a background vire beside the content view
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: myCornerRadius
        ).cgPath
    }
    
    func setUp(_ column: Int, _ text: String = "") {
        self.column = column
        self.myCornerRadius = column == 2 ? 10 : 0
        self.label.text = text
        self.setupShadow()
    }
    
    func setupShadow() {
        
        // Apply rounded corners to contentView
        contentView.layer.cornerRadius = myCornerRadius
        contentView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        contentView.layer.masksToBounds = true
        
        // Set masks to bounds to false to avoid the shadow
        // from being clipped to the corner radius
        layer.cornerRadius = myCornerRadius
        layer.masksToBounds = false
        
        // Apply a shadow
        layer.shadowRadius = 2
        layer.shadowOpacity = 1
        layer.shadowColor = Theme.FSCalendarStandardLightSelectionColor.cgColor
        let shadowWidht = column == 1 ? -2 : 0
        layer.shadowOffset = CGSize(width: shadowWidht, height: 0)
    }
}
