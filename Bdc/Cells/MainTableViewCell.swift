//
//  MainTableViewCell.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 22/10/21.
//

import UIKit

protocol MainTableViewCellDelegate: class {
    func mainCell(_ cell: MainTableViewCell, didSelectRowAt indexPath: IndexPath)
}

class MainTableViewCell: UITableViewCell {
    
    weak var delegate: MainTableViewCellDelegate?
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var mainButton: UIButton!
    
    var indexPath = IndexPath()
    var isAmonished = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.mainButton.isHidden = true
        self.mainImageView.layer.cornerRadius = self.mainImageView.frame.height / 2
    }
    
    func setUp(_ person: Person,_ isAdmonished: Bool = false,_ indexPath: IndexPath, _ delegate: MainTableViewCellDelegate) {
        self.delegate = delegate
        self.indexPath = indexPath
        self.isAmonished = isAdmonished
        self.nameLabel.text = person.name
        let imageString = CommonUtility.getProfileImageString(person)
        self.mainImageView.image = UIImage(named: imageString)
        if indexPath.section == 0 {
            self.mainButton.isHidden = true
            self.contentView.backgroundColor = .white
        } else {
            self.mainButton.isHidden = false
            self.contentView.backgroundColor = isAdmonished ? .yellow : .white
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func buttonDidTap(_ sender: Any) {
        self.delegate?.mainCell(self, didSelectRowAt: self.indexPath)
    }
    
}
