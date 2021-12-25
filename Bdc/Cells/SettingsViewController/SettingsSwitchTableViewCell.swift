//
//  SettingsSwitchTableViewCell.swift
//  Bdc
//
//  Created by leobartowski on 25/12/21.
//

import UIKit

class SettingsSwitchTableViewCell: UITableViewCell {

    @IBOutlet var mainLabel: UILabel!
    @IBOutlet var mainSwitch: UISwitch!
    
    var userDefaultKey = ""

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(text: String, userDefaultKey: String) {
        self.userDefaultKey = userDefaultKey
        self.mainLabel.text = text
        self.mainSwitch.isOn = UserDefaults.standard.bool(forKey: userDefaultKey)
    }

    @IBAction func mainSwitchValueChanged(_ sender: Any) {
        UserDefaults.standard.set(self.mainSwitch.isOn, forKey: self.userDefaultKey)
    }
}
