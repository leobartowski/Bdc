//
//  HandlePersonsTableViewCell.swift
//  Bdc
//
//  Created by leobartowski on 26/12/21.
//

import UIKit


class HandlePersonTableViewCell: UITableViewCell {
    
    
    @IBOutlet var mainImageView: UIImageView!
    @IBOutlet var mainTextField: UITextField!
    
    var person: Person!
    
    override func awakeFromNib() {
        self.mainImageView.layer.cornerRadius = self.mainImageView.frame.height / 2
        self.mainTextField.isEnabled = false
    }
    
    func setup(_ person: Person) {
        self.person = person
        self.mainTextField.text = person.name
        DispatchQueue.main.async {
            let imageString = CommonUtility.getProfileImageString(person)
            self.mainImageView.image = UIImage(named: imageString)
        }
    }
}

