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
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var attendanceLabel: UILabel!
    @IBOutlet weak var admonishmentLabel: UILabel!
    
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
        self.containerView.layer.cornerRadius = 15
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("RankingSectionHeaderView", owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.setupLabelTap()
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

