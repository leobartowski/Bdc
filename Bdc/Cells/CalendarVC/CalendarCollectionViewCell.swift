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

class CalendarCollectionViewCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    
    weak var delegate: CalendarCollectionViewCellDelegate?
    @IBOutlet var mainImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var customBackgroundView: UIView!

    var indexPath = IndexPath()

    override func awakeFromNib() {
        super.awakeFromNib()
        mainImageView.layer.cornerRadius = mainImageView.frame.height / 2
    }

    func setUp(_ person: Person, _ isAdmonished: Bool = false, _ indexPath: IndexPath, _ delegate: CalendarCollectionViewCellDelegate) {
        self.delegate = delegate
        self.indexPath = indexPath
        nameLabel.text = person.name
        let imageString = CommonUtility.getProfileImageString(person)
        mainImageView.image = UIImage(named: imageString)
        if indexPath.section != 0 { setupLongGestureRecognizer() }
        customBackgroundView.backgroundColor = indexPath.section == 0 ? .white : (isAdmonished ? .yellow : .white)
        setUpShadow()
    }

    func setUpShadow() {
        customBackgroundView.layer.cornerRadius = 10
        customBackgroundView.layer.masksToBounds = true
        customBackgroundView.layer.shadowColor = UIColor.gray.cgColor
        customBackgroundView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        customBackgroundView.layer.shadowOpacity = 0.3
        customBackgroundView.layer.shadowRadius = 2
        customBackgroundView.layer.shadowPath = UIBezierPath(roundedRect: customBackgroundView.bounds, cornerRadius: 10).cgPath
        customBackgroundView.layer.masksToBounds = false
    }

    private func setupLongGestureRecognizer() {
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        lpgr.minimumPressDuration = 0.5
        lpgr.delegate = self
        customBackgroundView.addGestureRecognizer(lpgr)
    }

    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        // Only the not Present Persons (section = 1) can use long Press Gesture Recoginzer
        if gestureReconizer.state == .began, indexPath.section == 1 {
            delegate?.mainCell(self, didSelectRowAt: indexPath)
            return
        }
    }
}
