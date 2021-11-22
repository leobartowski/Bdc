//
//  NameSpreadSheetCell.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 21/11/21.
//
import UIKit
import SpreadsheetView

class NameSpreadSheetCell: Cell {
    
    let label = UILabel()
    var imageView = UIImageView()
    var column = Int()
    
    override var frame: CGRect {
        didSet {
            // The cell height is 60 and the weidth is 160
            label.frame = CGRect(x: 70, y: 10, width: 80, height: 40)
            imageView.frame = CGRect(x: 20, y: 10, width: 40, height: 40)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear // Needed because there is a background vire beside the content view
        contentView.backgroundColor = .white
        
        label.frame = bounds
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        contentView.addSubview(label)
        contentView.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setUp(_ person: Person) {
        self.label.text = person.name ?? ""
        let imageString = CommonUtility.getProfileImageString(person)
        self.imageView.image = UIImage(named: imageString)
        self.setUpCornerRadius()
    }
    
    func setUpCornerRadius() {
        
        imageView.layer.cornerRadius = imageView.frame.height / 2
        contentView.layer.borderWidth = 0.2
        contentView.layer.borderColor = Theme.FSCalendarStandardSelectionColor.cgColor
        
        contentView.layer.cornerRadius = 15
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        contentView.clipsToBounds = true
    }
}
