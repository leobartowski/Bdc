//
//  CalendarCollectionViewCell.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 19/11/21.
//

import Foundation
import UIKit

protocol CalendarCollectionViewCellDelegate: class {
    func mainCell(_ cell: CalendarCollectionViewCell, didSelectRowAt indexPath: IndexPath)
}

class CalendarCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: CalendarCollectionViewCellDelegate?
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var customBackgroundView: UIView!
//    @IBOutlet weak var mainButton: UIButton!
    
    var indexPath = IndexPath()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.customBackgroundView.backgroundColor = .white
//        self.mainButton.isHidden = true
        
    }
    
    override func draw(_ rect: CGRect) {
        self.mainImageView.layer.cornerRadius = self.mainImageView.frame.height / 2
        self.customBackgroundView.layer.cornerRadius = 10
        self.customBackgroundView.layer.masksToBounds = false
        self.customBackgroundView.layer.shadowOpacity = 0.23
        self.customBackgroundView.layer.shadowRadius = 4
        self.customBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.customBackgroundView.layer.shadowColor = UIColor.black.cgColor
    }
    
    func setUp(_ person: Person,_ isAdmonished: Bool = false,_ indexPath: IndexPath, _ delegate: CalendarCollectionViewCellDelegate) {
        self.delegate = delegate
        self.indexPath = indexPath
        self.nameLabel.text = person.name
        let imageString = CommonUtility.getProfileImageString(person)
        self.mainImageView.image = UIImage(named: imageString)
//        if indexPath.section == 0 {
//            self.mainButton.isHidden = true
//            self.contentView.backgroundColor = .white
//        } else {
//            self.mainButton.isHidden = false
//            self.contentView.backgroundColor = isAdmonished ? .yellow : .white
//        }
    }
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//    }
    
    
    @IBAction func buttonDidTap(_ sender: Any) {
        self.delegate?.mainCell(self, didSelectRowAt: self.indexPath)
    }
}
