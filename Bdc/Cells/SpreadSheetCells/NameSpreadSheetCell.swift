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
            label.frame = CGRect(x: 75, y: 10, width: 90, height: 40)
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: 10
        ).cgPath
    }
    
    func setUp(_ person: Person) {
        self.label.text = person.name ?? ""
        let imageString = CommonUtility.getProfileImageString(person)
        self.imageView.image = UIImage(named: imageString)
        self.setUpShadow()
    }
    
    func setUpShadow() {
        
        imageView.layer.cornerRadius = imageView.frame.height / 2
        
        contentView.layer.cornerRadius = 10
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        contentView.layer.masksToBounds = true
        
        // Set masks to bounds to false to avoid the shadow
        // from being clipped to the corner radius
        layer.cornerRadius = 10
        layer.masksToBounds = false
        
        // Apply a shadow
        layer.shadowRadius = 2
        layer.shadowOpacity = 1
        layer.shadowColor = Theme.FSCalendarStandardLightSelectionColor.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}
