//
//  SettingsViewController.swift
//  Bdc
//
//  Created by leobartowski on 25/12/21.
//

import Foundation
import UIKit
import SafariServices

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        self.tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
        self.setupTableViewShadow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func setupTableViewShadow() {
        self.tableView.layer.masksToBounds = false
        self.tableView.layer.shadowColor = UIColor.gray.cgColor // any value you want
        self.tableView.layer.shadowOpacity = 0.3 // any value you want
        self.tableView.layer.shadowRadius = 2 // any value you want
        self.tableView.layer.shadowOffset = .init(width: 0, height: 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0: // First Section
            
            switch indexPath.row {
            case 0: // Modify Old Element
                let cell = tableView.dequeueReusableCell(withIdentifier: "switchCellID", for: indexPath) as? SettingsSwitchTableViewCell
                cell?.setup(text: "Abilita modifica giorni passati", settingsType: .modifyOldDays)
                return cell ?? UITableViewCell()
            case 1: // Handle Persons List
                let cell = tableView.dequeueReusableCell(withIdentifier: "arrowCellID", for: indexPath) as? SettingsArrowTableViewCell
                cell?.setup(text: "Gestisci persone", settingsType: .handlePersonList)
                return cell ?? UITableViewCell()
            default:
                return UITableViewCell()
            }
        case 1: // Second Section
            let cell = tableView.dequeueReusableCell(withIdentifier: "arrowCellID", for: indexPath) as? SettingsArrowTableViewCell
            cell?.setup(text: "Regolamento", settingsType: .showRegulation)
            return cell ?? UITableViewCell()
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0: // First Section
            
            switch indexPath.row {
            case 0:  return // Modify Old Element
            case 1: // Handle Persons List
                self.performSegue(withIdentifier: "segueToHandlePersons", sender: self)
                self.tableView.deselectRow(at: indexPath, animated: false)
            default: return
            }
        case 1:
            if let url = URL(string: "https://drive.google.com/file/d/1fvKB4Tbz4FOWQvNWF4ncY0XhpRdPdDB-/view?usp=sharing") {
                let svc = SFSafariViewController(url: url)
                self.present(svc, animated: true, completion: nil)
                self.tableView.deselectRow(at: indexPath, animated: false)
            }
        default:
            return
        }
    }

}

