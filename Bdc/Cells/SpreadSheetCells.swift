//
//  SpreadSheetCells.swift
//  Bdc
//
//  Created by Kishikawa Katsumi on 5/18/17.
//  Copyright © 2017 Kishikawa Katsumi. All rights reserved.
//

import UIKit
import SpreadsheetView

protocol HeaderCellDelegate: class {
    func headerCell(_ cell: HeaderCell, didSelectRowAt column: Int)
}

class HeaderCell: Cell {
    
    let label = UILabel()
    var column = Int()
    
    weak var delegate: HeaderCellDelegate?
    
    override var frame: CGRect {
        didSet {
            label.frame = bounds.insetBy(dx: 4, dy: 2)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.frame = bounds
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        contentView.addSubview(label)
        
        setupLabelTap()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func setUp(_ column: Int, _ delegate: HeaderCellDelegate) {
        self.delegate = delegate
        self.column = column
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

public enum Sorting {
    case ascending
    case descending

    var symbol: String {
        switch self {
        case .ascending:
            return "\u{25B2}"
        case .descending:
            return "\u{25BC}"
        }
    }
}

class TextCell: Cell {
    
    let label = UILabel()
    var imageView = UIImageView()
    
    
    override func prepareForReuse() {
        self.backgroundColor = .white
        label.frame = bounds.insetBy(dx: 10, dy: 2)
        imageView.removeFromSuperview()
        imageView.frame = .null
    }
    
    override var frame: CGRect {
        didSet {
            label.frame = bounds.insetBy(dx: 10, dy: 2)
            imageView.frame = .null
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.2)
        selectedBackgroundView = backgroundView
        
        label.frame = bounds
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        
        contentView.addSubview(label)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


class NameCell: Cell {
    
    let label = UILabel()
    var imageView = UIImageView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = 20
    }
    
    override func prepareForReuse() {
        self.backgroundColor = .white
    }
    
    override var frame: CGRect {
        didSet {
            // The cell height is 60 and the weidth is 160
            label.frame = CGRect(x: 65, y: 10, width: 90, height: 40)
            imageView.frame = CGRect(x: 15, y: 10, width: 40, height: 40)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.2)
        selectedBackgroundView = backgroundView
        
        label.frame = bounds
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        contentView.addSubview(label)
        contentView.addSubview(imageView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
