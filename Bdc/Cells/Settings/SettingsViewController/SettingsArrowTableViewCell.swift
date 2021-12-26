//
//  SettingsArrowTableViewCell.swift
//  Bdc
//
//  Created by leobartowski on 26/12/21.
//

import UIKit

class SettingsArrowTableViewCell: UITableViewCell {
    
    @IBOutlet var mainLabel: UILabel!
    
    var settingsType: SettingsType!
    
    override class func awakeFromNib() {
        
    }
    
    func setup(text: String, settingsType: SettingsType) {
        self.settingsType = settingsType
        self.mainLabel.text = text
    }
    
}
