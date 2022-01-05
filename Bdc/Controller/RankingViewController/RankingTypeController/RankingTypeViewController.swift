//
//  RankingTypeViewController.swift
//  Bdc
//
//  Created by leobartowski on 21/12/21.
//

import UIKit

class RankingTypeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var tableView: UITableView!
    
    let types = ["Settimanale", "Mensile" , "Annuale", "All-Time"]
    var selectedType: RankingType = .weekly
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.isHidden = true
        // We set the selectedType based on the current rankingType in RankingVc
        self.tableView.selectRow(at: IndexPath(row: self.selectedType.rawValue, section: 0), animated: false, scrollPosition: .none)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.types.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as? RankingTypeBottomSheetTableViewCell
        cell?.setup(self.types[indexPath.row], self.selectedType, indexPath)
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedType = RankingType(rawValue: indexPath.row) ?? .weekly
        let cell = tableView.cellForRow(at: indexPath) as? RankingTypeBottomSheetTableViewCell
        cell?.checkBox.select()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? RankingTypeBottomSheetTableViewCell
        cell?.checkBox.deselect()
    }
}
