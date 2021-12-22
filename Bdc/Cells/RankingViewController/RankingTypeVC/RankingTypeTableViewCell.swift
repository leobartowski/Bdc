//
//  RankingTypeTableViewCell.swift
//  Bdc
//
//  Created by leobartowski on 22/12/21.
//

import Foundation
import UIKit

protocol RankingTypeTableViewCellDelegate: AnyObject {
    
    func mainCell(_ cell: RankingTypeTableViewCell, didSelectRowAt indexPath: IndexPath)
    func mainCell(_ cell: RankingTypeTableViewCell, didDeselectRowAt indexPath: IndexPath)
}

class RankingTypeTableViewCell: UITableViewCell {
    
    @IBOutlet var mainLabel: UILabel!
    @IBOutlet var checkBox: CheckBox!
    
    var indexPath = IndexPath()
    var myRankingType: RankingType = .weekly
    
    weak var delegate: RankingTypeTableViewCellDelegate?
    
    override func awakeFromNib() {
        self.checkBox.selectedColor = Theme.FSCalendarStandardSelectionColor
    }
    
    func setup(_ title: String, _ selectedRankingType: RankingType, _ indexPath: IndexPath, _ delegate: RankingTypeTableViewCellDelegate) {
        self.delegate = delegate
        self.mainLabel.text = title
        self.indexPath = indexPath
        self.myRankingType = RankingType(rawValue: self.indexPath.row) ?? .weekly
        self.myRankingType == selectedRankingType ? self.checkBox.select() : self.checkBox.deselect()
        self.checkBox.onSelect { self.delegate?.mainCell(self, didSelectRowAt: indexPath) }
        self.checkBox.onDeselect { self.delegate?.mainCell(self, didDeselectRowAt: indexPath) }
    }
}
