//
//  HeaderSpreadSheetCell.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 21/11/21.
//

import UIKit
import SpreadsheetView

protocol HeaderCellDelegate: class {
    func headerCell(_ cell: HeaderSpreadSheetCell, didSelectRowAt column: Int)
}

class HeaderSpreadSheetCell: Cell {
    
    let label = UILabel()
    var column = Int()
    
    weak var delegate: HeaderCellDelegate?
    
    override var frame: CGRect {
        didSet {
            label.frame = bounds.insetBy(dx: 4, dy: 2)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear // Needed because there is a background vire beside the content view
        
        label.frame = bounds
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        contentView.addSubview(label)
        
        contentView.backgroundColor = Theme.FSCalendarStandardSelectionColor
        
        setupLabelTap()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func setUp(_ column: Int,_ text: String, _ delegate: HeaderCellDelegate) {
        self.delegate = delegate
        self.column = column
        self.label.text = text
        self.setUpCorner()
    }
    
    func setUpCorner() {
        if column == 0 {
            contentView.layer.cornerRadius = 10
            contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        } else if column == 2 {
            contentView.layer.cornerRadius = 10
            contentView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        }
    
    }
    
    // MARK: Label GestureRecognizer
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        self.delegate?.headerCell(self, didSelectRowAt: self.column)
    }
    
    func setupLabelTap() {
        
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped(_:)))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(labelTap)
    }
}
