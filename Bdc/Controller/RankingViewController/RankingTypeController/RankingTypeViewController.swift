//
//  RankingTypeViewController.swift
//  Bdc
//
//  Created by leobartowski on 21/12/21.
//

import UIKit

class RankingTypeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, RankingTypeTableViewCellDelegate {
    
    
    @IBOutlet var tableView: UITableView!
    
    let types = ["Settimanale", "Mensile" , "Annuale"]
    var selectedType: RankingType = .weekly
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.types.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as? RankingTypeTableViewCell
        cell?.setup(self.types[indexPath.row], self.selectedType, indexPath, self)
        return cell ?? UITableViewCell()
    }
    
    // MARK: RankingTypeTableViewCellDelegate
    
    func mainCell(_ cell: RankingTypeTableViewCell, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    func mainCell(_ cell: RankingTypeTableViewCell, didSelectRowAt indexPath: IndexPath) {
        self.selectedType = RankingType(rawValue: indexPath.row) ?? .weekly
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

}
