//
//  SectionHeader.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 21/10/21.
//

import Foundation
import UIKit

protocol RankingSectionHeaderDelegate: AnyObject {
    
    func rankingSectionHeaderView(_ cell: RankingSectionHeaderView, didSelectLabel number: Int)
}

class RankingSectionHeaderView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var attendanceLabel: UILabel!
    @IBOutlet var admonishmentLabel: UILabel!

    weak var delegate: RankingSectionHeaderDelegate?

    // MARK: Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func layoutSubviews() {
        self.containerView.layer.cornerRadius = self.containerView.frame.height / 4
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("RankingSectionHeaderView", owner: self, options: nil)
        addSubview(self.contentView)
        self.contentView.frame = bounds
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        self.setupLabelTap()
    }

    /// Update label weight based on sorting type (name, attendence or admonishmenr)
    func setupLabelDesign(_ labelNumber: Int) {
        let fontSize: CGFloat = 20
        switch labelNumber {
        case 0:
            self.nameLabel.font = .systemFont(ofSize: fontSize, weight: .medium)
            self.attendanceLabel.font = .systemFont(ofSize: fontSize, weight: .light)
            self.admonishmentLabel.font = .systemFont(ofSize: fontSize, weight: .light)
        case 1:
            self.nameLabel.font = .systemFont(ofSize: fontSize, weight: .light)
            self.attendanceLabel.font = .systemFont(ofSize: fontSize, weight: .medium)
            self.admonishmentLabel.font = .systemFont(ofSize: fontSize, weight: .light)
        case 2:
            self.nameLabel.font = .systemFont(ofSize: fontSize, weight: .light)
            self.attendanceLabel.font = .systemFont(ofSize: fontSize, weight: .light)
            self.admonishmentLabel.font = .systemFont(ofSize: fontSize, weight: .medium)
        default:
            break
        }
    }

    // MARK: Label GestureRecognizer

    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        self.delegate?.rankingSectionHeaderView(self, didSelectLabel: sender.view?.tag ?? 1)
    }

    func setupLabelTap() {
        let nameLabelTap = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped(_:)))
        self.nameLabel.isUserInteractionEnabled = true
        self.nameLabel.addGestureRecognizer(nameLabelTap)

        let attendanceLabelTap = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped(_:)))
        self.attendanceLabel.isUserInteractionEnabled = true
        self.attendanceLabel.addGestureRecognizer(attendanceLabelTap)

        let admonishmentLabelTap = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped(_:)))
        self.admonishmentLabel.isUserInteractionEnabled = true
        self.admonishmentLabel.addGestureRecognizer(admonishmentLabelTap)
    }
}
