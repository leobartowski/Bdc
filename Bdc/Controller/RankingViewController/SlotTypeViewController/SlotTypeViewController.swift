//
//  RankingTypeViewController.swift
//  Bdc
//
//  Created by leobartowski on 30/08/22.
//

import UIKit

class SlotTypeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var tableView: UITableView!
    
    let types = ["Mattina & Pomeriggio", "Mattina", "Pomeriggio"]
    var selectedSlot: SlotType = .morningAndEvening
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.isHidden = true
        // We set the selectedType based on the current rankingType in RankingVc
        self.tableView.selectRow(at: IndexPath(row: self.selectedSlot.rawValue, section: 0), animated: false, scrollPosition: .none)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.types.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as? FilterBottomSheetTableViewCell
        cell?.setupSlotType(self.types[indexPath.row], self.selectedSlot, indexPath)
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedSlot = SlotType(rawValue: indexPath.row) ?? .morningAndEvening
        let cell = tableView.cellForRow(at: indexPath) as? FilterBottomSheetTableViewCell
        cell?.checkBox.select()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? FilterBottomSheetTableViewCell
        cell?.checkBox.deselect()
    }
}

