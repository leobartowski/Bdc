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
    
    var settingsType: SettingsType!

    func setup(text: String, settingsType: SettingsType) {
        self.settingsType = settingsType
        self.mainLabel.text = text
        self.mainSwitch.isOn = UserDefaults.standard.bool(forKey: self.settingsType.rawValue)
    }

    @IBAction func mainSwitchValueChanged(_ sender: Any) {
        
        UserDefaults.standard.set(self.mainSwitch.isOn, forKey: self.settingsType.rawValue)
        switch self.settingsType {
        case .modifyOldDays:
            let notification = Notification(name: .didChangeModifyStatus, object: nil, userInfo: nil)
            NotificationCenter.default.post(notification)
        case .showStatistics:
            let notification = Notification(name: .didChangeShowStatistics, object: nil, userInfo: nil)
            NotificationCenter.default.post(notification)
        case .showConfetti:
            let notification = Notification(name: .didChangeShowConfetti, object: nil, userInfo: nil)
            NotificationCenter.default.post(notification)
        default:
            break
        }

    }
}
