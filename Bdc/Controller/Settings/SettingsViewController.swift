//
//  SettingsViewController.swift
//  Bdc
//
//  Created by leobartowski on 25/12/21.
//

import Foundation
import UIKit
import SafariServices
import AcknowList

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        self.tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
        self.setupTableViewShadow()
    }

    func setupTableViewShadow() {
        self.tableView.layer.masksToBounds = false
        self.tableView.layer.shadowColor = UIColor.gray.cgColor // any value you want
        self.tableView.layer.shadowOpacity = 0.3 // any value you want
        self.tableView.layer.shadowRadius = 2 // any value you want
        self.tableView.layer.shadowOffset = .init(width: 0, height: 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return 1
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0: // First Section
            
            switch indexPath.row {
            case 0: // Modify Old Element
                let cell = tableView.dequeueReusableCell(withIdentifier: "switchCellID", for: indexPath) as? SettingsSwitchTableViewCell
                cell?.setup(text: "Abilita modifica giorni passati", settingsType: .modifyOldDays)
                return cell ?? UITableViewCell()
            case 1: // S
                let cell = tableView.dequeueReusableCell(withIdentifier: "switchCellID", for: indexPath) as? SettingsSwitchTableViewCell
                cell?.setup(text: "Mostra statistiche ranking", settingsType: .showStatistics)
                return cell ?? UITableViewCell()
            case 2: // Show confetti view
                let cell = tableView.dequeueReusableCell(withIdentifier: "switchCellID", for: indexPath) as? SettingsSwitchTableViewCell
                cell?.setup(text: "Mostra coriandoli periodo perfetto", settingsType: .showConfetti)
                return cell ?? UITableViewCell()
            case 3: //  Weighted Attendance
                let cell = tableView.dequeueReusableCell(withIdentifier: "switchCellID", for: indexPath) as? SettingsSwitchTableViewCell
                cell?.setup(text: "Calcola presenze All-Time ponderate", settingsType: .weightedAttendance)
                return cell ?? UITableViewCell()

            default:
                return UITableViewCell()
            }
        case 1: // Handle Persons List
            let cell = tableView.dequeueReusableCell(withIdentifier: "arrowCellID", for: indexPath) as? SettingsArrowTableViewCell
            cell?.setup(text: "Gestisci persone", settingsType: .handlePersonList)
            return cell ?? UITableViewCell()
        case 2: // Second Section
            let cell = tableView.dequeueReusableCell(withIdentifier: "arrowCellID", for: indexPath) as? SettingsArrowTableViewCell
            cell?.setup(text: "Regolamento", settingsType: .showRegulation)
            return cell ?? UITableViewCell()
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "arrowCellID", for: indexPath) as? SettingsArrowTableViewCell
            cell?.setup(text: "Software terze parti", settingsType: .acknowledgmentThirdPartSoftware)
            return cell ?? UITableViewCell()
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0: // First Section
            
            switch indexPath.row {
            case 0: return // Modify Old Element
            case 1: return // Show Statistics
            case 2: return // Show confetti
            case 3: return // Weighted Attendance
            default: return
            }
        case 1: // Handle Person list
            self.performSegue(withIdentifier: "segueToHandlePersons", sender: self)
            self.tableView.deselectRow(at: indexPath, animated: false)
        case 2: // 
            if let url = URL(string: "https://drive.google.com/file/d/1fvKB4Tbz4FOWQvNWF4ncY0XhpRdPdDB-/view?usp=sharing") {
                let safariVC = SFSafariViewController(url: url)
                safariVC.preferredBarTintColor = .white
                safariVC.preferredControlTintColor = Theme.FSCalendarStandardSelectionColor
                self.present(safariVC, animated: true, completion: nil)
                self.tableView.deselectRow(at: indexPath, animated: false)
            }
        case 3:
            let viewController = AcknowListViewController()
            viewController.acknowledgements.append(contentsOf: self.createCustomLicenseToAcknowVC())
            viewController.title = "Riconoscimenti"
            viewController.acknowledgements.sort(by: { $0.title < $1.title })
            viewController.headerText = "Ecco una lista di software gratuiti e open-source che sono stati usati per creare l'app BdC:"
            viewController.footerText = ""
            self.navigationController?.pushViewController(viewController, animated: true)
            self.tableView.deselectRow(at: indexPath, animated: false)
        default:
            return
        }
    }
    
    private func createCustomLicenseToAcknowVC() -> [Acknow] {
        var acknows: [Acknow] = []
        acknows.append(Acknow(title: "SwiftFormat", text: self.readFromFile("LicenseSwiftFormat")))
        acknows.append(Acknow(title: "SwiftHoliday", text: self.readFromFile("LicenseSwiftHoliday")))
        acknows.append(Acknow(title: "LTHRadioButton", text: self.readFromFile("LicenseLTHRadioButton")))
        acknows.append(Acknow(title: "CocoaPods", text: self.readFromFile("LicenseCocoaPods")))
        return acknows
    }
    
    private func readFromFile(_ fileName: String) -> String {
        if let filepath = Bundle.main.path(forResource: fileName, ofType: "txt") {
            do {
                let contents = try String(contentsOfFile: filepath)
                return contents
            } catch {
                return ""
            }
        } else {
            return ""
        }
    }
}
