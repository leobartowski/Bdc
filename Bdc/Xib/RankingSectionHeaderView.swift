//
//  SectionHeader.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 21/10/21.
//

import Foundation
import UIKit

protocol RankingSectionHeaderDelegate: class {
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
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func layoutSubviews() {
        containerView.layer.cornerRadius = containerView.frame.height / 4
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("RankingSectionHeaderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        setupLabelTap()
    }

    /// Update label weight based on sorting type (name, attendence or admonishmenr)
    func setupLabelDesign(_ labelNumber: Int) {
        let fontSize: CGFloat = 20
        switch labelNumber {
        case 0:
            nameLabel.font = .systemFont(ofSize: fontSize, weight: .medium)
            attendanceLabel.font = .systemFont(ofSize: fontSize, weight: .light)
            admonishmentLabel.font = .systemFont(ofSize: fontSize, weight: .light)
        case 1:
            nameLabel.font = .systemFont(ofSize: fontSize, weight: .light)
            attendanceLabel.font = .systemFont(ofSize: fontSize, weight: .medium)
            admonishmentLabel.font = .systemFont(ofSize: fontSize, weight: .light)
        case 2:
            nameLabel.font = .systemFont(ofSize: fontSize, weight: .light)
            attendanceLabel.font = .systemFont(ofSize: fontSize, weight: .light)
            admonishmentLabel.font = .systemFont(ofSize: fontSize, weight: .medium)
        default:
            break
        }
    }

    // MARK: Label GestureRecognizer

    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        delegate?.rankingSectionHeaderView(self, didSelectLabel: sender.view?.tag ?? 1)
    }

    func setupLabelTap() {
        let nameLabelTap = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
        nameLabel.isUserInteractionEnabled = true
        nameLabel.addGestureRecognizer(nameLabelTap)

        let attendanceLabelTap = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
        attendanceLabel.isUserInteractionEnabled = true
        attendanceLabel.addGestureRecognizer(attendanceLabelTap)

        let admonishmentLabelTap = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
        admonishmentLabel.isUserInteractionEnabled = true
        admonishmentLabel.addGestureRecognizer(admonishmentLabelTap)
    }
}
