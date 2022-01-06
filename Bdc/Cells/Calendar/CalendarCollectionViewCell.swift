//
//  CalendarCollectionViewCell.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 19/11/21.
//

import Foundation
import UIKit

protocol CalendarCollectionViewCellDelegate: AnyObject {
    
    func mainCell(_ cell: CalendarCollectionViewCell, didSelectRowAt indexPath: IndexPath)
}

class CalendarCollectionViewCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    
    weak var delegate: CalendarCollectionViewCellDelegate?
    @IBOutlet var mainImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var customBackgroundView: UIView!

    var indexPath = IndexPath()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.mainImageView.layer.cornerRadius = self.mainImageView.frame.height / 2
    }

    func setUp(_ person: Person, _ isAdmonished: Bool = false, _ indexPath: IndexPath, _ delegate: CalendarCollectionViewCellDelegate) {
        self.delegate = delegate
        self.indexPath = indexPath
        self.nameLabel.text = person.name
        let imageString = CommonUtility.getProfileImageString(person)
        self.mainImageView.image = UIImage(named: imageString)
        if indexPath.section != 0 { self.setupLongGestureRecognizer() }
        self.customBackgroundView.backgroundColor = indexPath.section == 0 ? .white : (isAdmonished ? .yellow : .white)
        self.setUpShadow()
    }

    func setUpShadow() {
        self.customBackgroundView.layer.cornerRadius = 10
        self.customBackgroundView.layer.masksToBounds = true
        self.customBackgroundView.layer.shadowColor = UIColor.gray.cgColor
        self.customBackgroundView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.customBackgroundView.layer.shadowOpacity = 0.3
        self.customBackgroundView.layer.shadowRadius = 2
        self.customBackgroundView.layer.shadowPath = UIBezierPath(roundedRect: self.customBackgroundView.bounds, cornerRadius: 10).cgPath
        self.customBackgroundView.layer.masksToBounds = false
    }

    private func setupLongGestureRecognizer() {
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        lpgr.minimumPressDuration = 0.5
        lpgr.delegate = self
        self.customBackgroundView.addGestureRecognizer(lpgr)
    }

    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        // Only the not Present Persons (section = 1) can use long Press Gesture Recoginzer
        if gestureReconizer.state == .began, self.indexPath.section == 1 {
            self.delegate?.mainCell(self, didSelectRowAt: self.indexPath)
            return
        }
    }
}