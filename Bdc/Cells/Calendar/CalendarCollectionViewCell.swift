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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var indexPath = IndexPath()

    var isUpdating: Bool = false {
        didSet {
            self.isUpdating ? self.showLoader() : self.hideLoader()
        }
    }
    
    override func prepareForReuse() {
        self.customBackgroundView.borderWidth = 0
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupLongGestureRecognizer()
        self.mainImageView.layer.cornerRadius = self.mainImageView.frame.height / 2
    }

    func setUp(_ person: Person, _ isPresent: Bool = false, _ isAdmonished: Bool = false, _ indexPath: IndexPath, _ delegate: CalendarCollectionViewCellDelegate) {
        self.delegate = delegate
        self.indexPath = indexPath
        self.isUpdating = false
        self.nameLabel.text = person.name
        let imageString = CommonUtility.getProfileImageString(person)
        self.mainImageView.image = UIImage(named: imageString)
        if isPresent {
            self.customBackgroundView.borderColor = Theme.main
            self.customBackgroundView.borderWidth = 2
        }
        self.customBackgroundView.backgroundColor = isAdmonished ? Theme.customYellow : Theme.dirtyWhite
        self.setUpShadow()
    }
    
    private func setUpShadow() {
        self.customBackgroundView.layer.cornerRadius = 10
        self.customBackgroundView.layer.masksToBounds = true
        if self.traitCollection.userInterfaceStyle != .dark {
            self.customBackgroundView.layer.shadowColor = UIColor.systemGray.cgColor
            self.customBackgroundView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            self.customBackgroundView.layer.shadowOpacity = 0.3
            self.customBackgroundView.layer.shadowRadius = 2
            self.customBackgroundView.layer.shadowPath = UIBezierPath(roundedRect: self.customBackgroundView.bounds, cornerRadius: 10).cgPath
            self.customBackgroundView.layer.masksToBounds = false
        }
    }
    
    func showLoader() {
        self.mainImageView.isHidden = true
        self.activityIndicator.startAnimating()
    }
    func hideLoader() {
        self.mainImageView.isHidden = false
        self.activityIndicator.stopAnimating()
    }

    private func setupLongGestureRecognizer() {
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        lpgr.minimumPressDuration = 0.5
        lpgr.delegate = self
        self.customBackgroundView.addGestureRecognizer(lpgr)
    }

    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state == .began {
            self.delegate?.mainCell(self, didSelectRowAt: self.indexPath)
            return
        }
    }
}
