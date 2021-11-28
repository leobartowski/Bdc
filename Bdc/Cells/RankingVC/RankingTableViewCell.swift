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
    @IBOutlet weak var collectionView: UICollectionView!
    
    var indexPath = IndexPath()
    
    let days = ["L", "M", "M", "G", "V"]
    var morningDaysNumbers: [Int] = []
    var eveningDaysNumbers: [Int] = []
    
    var isDetailViewHidden: Bool {
        return self.collectionView.isHidden
      }
    
    override func layoutSubviews() {
        self.containerView.layer.shadowPath = UIBezierPath(roundedRect: self.containerView.bounds, cornerRadius: 15).cgPath
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.autoresizingMask = .flexibleHeight
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.isHidden = true
        
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
        self.morningDaysNumbers = self.createNumbersArray(rankingAttendance.morningDate)
        self.eveningDaysNumbers = self.createNumbersArray(rankingAttendance.eveningDate)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if isDetailViewHidden, selected {
            self.collectionView.isHidden = false
        } else {
            
            self.collectionView.isHidden = true
        }
        self.contentView.layoutIfNeeded()
        self.contentView.updateConstraints()
        self.contentView.layoutIfNeeded()
        self.setNeedsLayout()
    }
    
    func setUpShadow() {
        let cornerRadius: CGFloat = 15
        self.containerView.cornerRadius = cornerRadius
        self.containerView.layer.masksToBounds = true
        self.containerView.layer.shadowColor = UIColor.gray.cgColor
        self.containerView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.containerView.layer.shadowOpacity = 0.3
        self.containerView.layer.shadowRadius = 2
//        self.containerView.layer.shadowPath = UIBezierPath(roundedRect: self.containerView.bounds, cornerRadius: cornerRadius).cgPath
        self.containerView.layer.masksToBounds = false
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
    
    // Given an array of date create an array of Int that represents the specifc number of the day in the weel
    func createNumbersArray(_ dates: [Date]) -> [Int] {
        var datesNumbers: [Int] = []
        for date in dates {
            datesNumbers.append(date.getDayNumberOfWeek() ?? 1)
        }
        return datesNumbers
    }
    
}
