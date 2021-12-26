//
//  SettingsViewController.swift
//  Bdc
//
//  Created by leobartowski on 25/12/21.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        self.setupTableViewShadow()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setupTableViewShadow() {
        self.tableView.layer.masksToBounds = false
        self.tableView.layer.shadowColor = UIColor.gray.cgColor // any value you want
        self.tableView.layer.shadowOpacity = 0.3 // any value you want
        self.tableView.layer.shadowRadius = 2 // any value you want
        self.tableView.layer.shadowOffset = .init(width: 0, height: 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0: // First Section
            
            switch indexPath.row {
            case 0: // Modify Old Element
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as? SettingsSwitchTableViewCell
                cell?.setup(text: "Abilita modifica giorni passati", settingsType: .modifyOldDays)
                return cell ?? UITableViewCell()
            default:
                return UITableViewCell()
            }
        case 1: // Second Section
            return UITableViewCell()
        default:
            return UITableViewCell()
        }
    }
}

