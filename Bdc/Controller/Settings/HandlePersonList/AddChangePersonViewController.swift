//
//  AddChangePersonViewController.swift
//  Bdc
//
//  Created by leobartowski on 28/12/21.
//

import UIKit

class AddChangePersonViewController: UIViewController {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var modifyButton: UIButton!
    @IBOutlet weak var mainTextField: UITextField!
    
    var person: Person!
    
    override func viewDidLoad() {
        self.setupUI()
        self.setUpData()
    }
    
    private func setupUI() {
        self.mainTextField.isEnabled = false
        self.mainImageView.layer.cornerRadius = self.mainImageView.frame.height / 2
        self.modifyButton.setTitle("Modifica", for: .normal)
        self.modifyButton.tag = 1
    }
    
    func setUpData() {
        self.mainTextField.text = self.person.name
        DispatchQueue.main.async {
            let imageString = CommonUtility.getProfileImageString(self.person)
            self.mainImageView.image = UIImage(named: imageString)
        }
    }
    
    @IBAction func modifyButtonAction(_ sender: Any) {
        
        if self.modifyButton.tag == 1 {
            
            self.mainTextField.isEnabled = true
            self.mainTextField.becomeFirstResponder()
            self.modifyButton.setTitle("Salva", for: .normal)
            self.modifyButton.tag = 2
        } else {
            guard let oldName = self.person.name, let newName = self.mainTextField.text else { return }
            let newNamePro = newName.capitalized.trimmingCharacters(in: .whitespacesAndNewlines) // Removed trimmingCharacters and upperCased first letter
            CoreDataService.shared.updateNameSpecificPerson(oldName: oldName, newName: newNamePro)
            self.mainTextField.isEnabled = false
            self.modifyButton.setTitle("Modifica", for: .normal)
            self.modifyButton.tag = 1
        }
    }
}
