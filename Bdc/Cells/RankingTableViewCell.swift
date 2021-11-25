//
//  RankingTableViewCell.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 23/11/21.
//

import Foundation
import UIKit



class RankingTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var attendanceLabel: UILabel!
    @IBOutlet weak var admonishmentLabel: UILabel!
    var indexPath = IndexPath()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.mainImageView.layer.cornerRadius = self.mainImageView.frame.height / 2
    }
    
    func setUp(_ rankingAttendance: RankingPersonAttendance,_ indexPath: IndexPath) {
        self.indexPath = indexPath
        self.setUpShadow()
        self.nameLabel.text = rankingAttendance.person.name
        self.attendanceLabel.text = String(rankingAttendance.attendanceNumber)
        self.admonishmentLabel.text = String(rankingAttendance.admonishmentNumber)
        let imageString = CommonUtility.getProfileImageString(rankingAttendance.person)
        self.mainImageView.image = UIImage(named: imageString)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUpShadow() {
        self.containerView.layer.shadowColor = UIColor.gray.cgColor
        self.containerView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.containerView.layer.shadowOpacity = 0.3
        self.containerView.layer.shadowRadius = 2
        self.containerView.layer.masksToBounds = false
        self.containerView.layer.cornerRadius = self.containerView.frame.height / 4
    }
    
    func setupLabelDesign(_ labelNumber: Int) {
        switch labelNumber {
        case 0:
            self.nameLabel.font = .systemFont(ofSize: 19, weight: .medium)
            self.attendanceLabel.font = .systemFont(ofSize: 19, weight: .light)
            self.admonishmentLabel.font = .systemFont(ofSize: 19, weight: .light)
        case 1:
            self.nameLabel.font = .systemFont(ofSize: 19, weight: .light)
            self.attendanceLabel.font = .systemFont(ofSize: 19, weight: .medium)
            self.admonishmentLabel.font = .systemFont(ofSize: 19, weight: .light)
        case 2:
            self.nameLabel.font = .systemFont(ofSize: 19, weight: .light)
            self.attendanceLabel.font = .systemFont(ofSize: 19, weight: .light)
            self.admonishmentLabel.font = .systemFont(ofSize: 19, weight: .medium)
        default:
            break
        }
    }
    
}
