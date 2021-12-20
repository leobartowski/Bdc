//
//  RankingTableViewCell.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 23/11/21.
//

import Foundation
import UIKit

class RankingTableViewCell: UITableViewCell {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var mainImageView: UIImageView!
    @IBOutlet var attendanceLabel: UILabel!
    @IBOutlet var admonishmentLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!

    var indexPath = IndexPath()

    let days = ["L", "M", "M", "G", "V"]
    var morningDaysNumbers: [Int] = []
    var eveningDaysNumbers: [Int] = []

    var isDetailViewHidden: Bool {
        return self.collectionView.isHidden
    }

    override func layoutSubviews() {
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: 15).cgPath
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.autoresizingMask = .flexibleHeight
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isHidden = true

        mainImageView.layer.cornerRadius = mainImageView.frame.height / 2
    }

    func setUp(_ rankingAttendance: RankingPersonAttendance, _ indexPath: IndexPath) {
        self.indexPath = indexPath
        setUpShadow()
        nameLabel.text = rankingAttendance.person.name
        attendanceLabel.text = String(rankingAttendance.attendanceNumber)
        admonishmentLabel.text = String(rankingAttendance.admonishmentNumber)
        let imageString = CommonUtility.getProfileImageString(rankingAttendance.person)
        mainImageView.image = UIImage(named: imageString)
        morningDaysNumbers = createNumbersArray(rankingAttendance.morningDate)
        eveningDaysNumbers = createNumbersArray(rankingAttendance.eveningDate)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if isDetailViewHidden, selected {
            collectionView.isHidden = false
        } else {
            collectionView.isHidden = true
        }
        contentView.layoutIfNeeded()
        contentView.updateConstraints()
        contentView.layoutIfNeeded()
        setNeedsLayout()
    }

    func setUpShadow() {
        let cornerRadius: CGFloat = 15
        containerView.cornerRadius = cornerRadius
        containerView.layer.masksToBounds = true
        containerView.layer.shadowColor = UIColor.gray.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        containerView.layer.shadowOpacity = 0.3
        containerView.layer.shadowRadius = 2
//        self.containerView.layer.shadowPath = UIBezierPath(roundedRect: self.containerView.bounds, cornerRadius: cornerRadius).cgPath
        containerView.layer.masksToBounds = false
    }

    func setupLabelDesign(_ labelNumber: Int) {
        switch labelNumber {
        case 0:
            nameLabel.font = .systemFont(ofSize: 19, weight: .medium)
            attendanceLabel.font = .systemFont(ofSize: 19, weight: .light)
            admonishmentLabel.font = .systemFont(ofSize: 19, weight: .light)
        case 1:
            nameLabel.font = .systemFont(ofSize: 19, weight: .light)
            attendanceLabel.font = .systemFont(ofSize: 19, weight: .medium)
            admonishmentLabel.font = .systemFont(ofSize: 19, weight: .light)
        case 2:
            nameLabel.font = .systemFont(ofSize: 19, weight: .light)
            attendanceLabel.font = .systemFont(ofSize: 19, weight: .light)
            admonishmentLabel.font = .systemFont(ofSize: 19, weight: .medium)
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
