//
//  HandlePersonsTableViewController.swift
//  Bdc
//
//  Created by leobartowski on 26/12/21.
//

import UIKit

class HandlePersonsTableViewController: UITableViewController {
    

    
    override func viewDidLoad() {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PersonListUtility.persons.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as? HandlePersonTableViewCell
        cell?.setup(PersonListUtility.persons[indexPath.row])
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let cell = tableView.cellForRow(at: indexPath) as? HandlePersonTableViewCell
            CoreDataService.shared.deletePersonFromPersonsList(name: cell?.person.name)
            DispatchQueue.main.async {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
        }
    }
}
