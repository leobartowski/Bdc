//
//  RankingTypeTableViewCell.swift
//  Bdc
//
//  Created by leobartowski on 22/12/21.
//

import Foundation
import UIKit

class FilterBottomSheetTableViewCell: UITableViewCell {
    
    @IBOutlet var mainLabel: UILabel!
    @IBOutlet var checkBox: CheckBox!
    
    override var isSelected: Bool {
        didSet {
            self.isSelected ? self.checkBox.select(animated: false) : self.checkBox.deselect()
        }
    }
    
    var indexPath = IndexPath()
    var myRankingType: RankingType = .weekly
    var mySlotType: SlotType = .morningAndEvening
    
    override func awakeFromNib() {
        self.checkBox.isUserInteractionEnabled = false
        self.checkBox.selectedColor = Theme.main
    }
    
    func setupRankingType(_ title: String, _ selectedRankingType: RankingType, _ indexPath: IndexPath) {
        self.mainLabel.text = title
        self.indexPath = indexPath
        self.myRankingType = RankingType(rawValue: self.indexPath.row) ?? .weekly
    }
    
    func setupSlotType(_ title: String, _ selectedSlotType: SlotType, _ indexPath: IndexPath) {
        self.mainLabel.text = title
        self.indexPath = indexPath
        self.mySlotType = SlotType(rawValue: self.indexPath.row) ?? .morningAndEvening
    }
}
