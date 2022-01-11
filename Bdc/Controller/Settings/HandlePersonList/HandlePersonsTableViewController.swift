//
//  HandlePersonsTableViewController.swift
//  Bdc
//
//  Created by leobartowski on 26/12/21.
//

import UIKit
import FittedSheets

class HandlePersonsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        self.tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
        self.setupTableViewShadow()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPerson))
        self.addObservers()
    }
    
    func setupTableViewShadow() {
        self.tableView.layer.masksToBounds = false
        self.tableView.layer.shadowColor = UIColor.gray.cgColor
        self.tableView.layer.shadowOpacity = 0.3
        self.tableView.layer.shadowRadius = 2 
        self.tableView.layer.shadowOffset = .init(width: 0, height: 0)
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.didChangePersonList(_:)), name: .didChangePersonList, object: nil)
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PersonListUtility.persons.count
    }
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? HandlePersonTableViewCell
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "addChangePersonVC") as? AddChangePersonViewController {
            vc.person = cell?.person
            let sheetController = SheetViewController(
                controller: vc,
                sizes: [.fixed(310)],
                options: SheetOptions(shrinkPresentingViewController: false)
            )

            sheetController.shouldDismiss = { _ in
                self.tableView.deselectRow(at: indexPath, animated: true)
                return true
            }
            sheetController.gripSize = CGSize(width: 35, height: 6)
            self.present(sheetController, animated: true, completion: nil)
        }
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as? HandlePersonTableViewCell
        cell?.setup(PersonListUtility.persons[indexPath.row])
        return cell ?? UITableViewCell()
    }
    
     func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
         
         let swipeActions = UISwipeActionsConfiguration(actions: [self.contextItemToDeleteRow(indexPath)])
        return swipeActions
    }
    
    private func deletePersonAndUpdateUI(_ name: String, _ indexPath: IndexPath) {
        self.tableView.beginUpdates()
        CoreDataService.shared.deletePersonFromPersonsList(name: name)
        DispatchQueue.main.async {
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.endUpdates()
        }
    }
    
    private func contextItemToDeleteRow(_ indexPath: IndexPath) -> UIContextualAction {
        let  contextItem = UIContextualAction(style: .destructive, title: "Elimina") {  (contextualAction, view, completionHandler) in
            
            let cell = self.tableView.cellForRow(at: indexPath) as? HandlePersonTableViewCell
            let name = cell?.person.name ?? ""
            self.presentActionSheet(title: "Sei sicuro di voler cancellare \(name) dalla lista di persone??? Quest'azione è irreversibile.", mainAction: { _ in
                self.deletePersonAndUpdateUI(name, indexPath)
                completionHandler(true)
            }, mainActionTitle: "Cancella \(name)") { _ in
                // TODO: Automatic close trailingSwipe
                self.dismiss(animated: false, completion: nil)
                completionHandler(true)
            }
        }
        return contextItem
    }
    
    // MARK: Add Person
    @objc func addPerson() {
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "addChangePersonVC") as? AddChangePersonViewController {
            let newPerson = Person(context: CoreDataService.shared.context)
            newPerson.name = "Persona" + String(Int.random(in: 0 ..< 100))
            CoreDataService.shared.addPersonToPersonList(newPerson)
            vc.person = newPerson
        
            let sheetController = SheetViewController(
                controller: vc,
                sizes: [.fixed(310)]
            )
            sheetController.gripSize = CGSize(width: 35, height: 6)
            self.present(sheetController, animated: true, completion: nil)
        }
    }
    
    // MARK: Handle changed PersonsList
    @objc func didChangePersonList(_: Notification) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
