//
//  RankingTableViewCell.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 23/11/21.
//

import Foundation
import UIKit



class RankingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var presenceLabel: UILabel!
    @IBOutlet weak var admonishmentLabel: UILabel!
    var indexPath = IndexPath()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.mainImageView.layer.cornerRadius = self.mainImageView.frame.height / 2
    }
    
    func setUp(_ person: Person,_ indexPath: IndexPath) {
        self.indexPath = indexPath
        self.nameLabel.text = person.name
        let imageString = CommonUtility.getProfileImageString(person)
        self.mainImageView.image = UIImage(named: imageString)

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
