//
//  RankingTypeViewController.swift
//  Bdc
//
//  Created by leobartowski on 21/12/21.
//

import UIKit

class RankingTypeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet  var tableView: UITableView!
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    
}
