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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as? HandlePersonTableViewCell
        cell?.setup(PersonListUtility.persons[indexPath.row])
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .destructive, title: "Elimina") {  (contextualAction, view, boolValue) in
            
            let cell = tableView.cellForRow(at: indexPath) as? HandlePersonTableViewCell
            let name = cell?.person.name ?? ""
            self.presentActionSheet(title: "Sei sicuro di voler cancellare \(name) dalla lista di persone??? Quest'azione è irreversibile.", mainAction: { _ in
                self.deletePersonAndUpdateUI(name, indexPath)
            }, mainActionTitle: "Cancella \(name)") { _ in
                self.dismiss(animated: true, completion: nil)
            }
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
        return swipeActions
    }
    
    private func deletePersonAndUpdateUI(_ name: String, _ indexPath: IndexPath) {
//        self.tableView.beginUpdates()
        CoreDataService.shared.deletePersonFromPersonsList(name: name)
        DispatchQueue.main.async {
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
//            self.tableView.endUpdates()
        }

    }
}
