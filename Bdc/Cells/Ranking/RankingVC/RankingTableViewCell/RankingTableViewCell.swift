//
//  RankingTableViewCell.swift
//  Bdc
//
//  Created by leobartowski on 09/01/22.
//

import UIKit

class RankingTableViewCell: UITableViewCell {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var mainImageView: UIImageView!
    @IBOutlet var attendanceLabel: UILabel!
    @IBOutlet var admonishmentLabel: UILabel!
    @IBOutlet var percentualAttendanceLabel: UILabel!
    @IBOutlet var percentualAdmonishmentLabel: UILabel!
    
    var indexPath = IndexPath()
    var rankingAttendance: RankingPersonAttendance?
    var rankingType: RankingType?
    var showStatistics = false
    var showWeightedAttendance = false

    override func layoutSubviews() {
        self.containerView.layer.shadowPath = UIBezierPath(roundedRect: self.containerView.bounds, cornerRadius: 15).cgPath
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.showStatistics = UserDefaults.standard.bool(forKey: "showStatistics")
        self.showWeightedAttendance = UserDefaults.standard.bool(forKey: "weightedAttendance")
        NotificationCenter.default.addObserver(self, selector: #selector(self.didChangeShowStatistics(_:)), name: .didChangeShowStatistics, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didChangeWeightedAttendance(_:)), name: .didChangeweightedAttendance, object: nil)
        // Design
        self.mainImageView.layer.cornerRadius = self.mainImageView.frame.height / 2
    }

    // MARK: SetUp
    func setUp(_ rankingAttendance: RankingPersonAttendance, _ indexPath: IndexPath, _ rankingType: RankingType) {
        self.indexPath = indexPath
        self.rankingAttendance = rankingAttendance
        self.rankingType = rankingType
        self.setUpShadow()
        self.nameLabel.text = rankingAttendance.person.name
        self.attendanceLabel.text = self.getStringOfAttendanceLabel(rankingAttendance, rankingType)
        self.admonishmentLabel.text = String(rankingAttendance.admonishmentNumber)
        self.handleStatistics()
        let imageString = CommonUtility.getProfileImageString(rankingAttendance.person)
        self.mainImageView.image = UIImage(named: imageString)
    }
    
    func getStringOfAttendanceLabel(_ rankingAttendance: RankingPersonAttendance, _ rankingType: RankingType) -> String {
        if self.showWeightedAttendance && rankingType == .allTime {
            let number = Float(rankingAttendance.attendanceNumber) * rankingAttendance.person.difficultyCoefficient
            return String(format: "%.1f", number)
        } else {
            return String(rankingAttendance.attendanceNumber)
        }
    }
    
    func setUpShadow() {
        let cornerRadius: CGFloat = 15
        self.containerView.cornerRadius = cornerRadius
        self.containerView.layer.masksToBounds = true
        self.containerView.layer.shadowColor = UIColor.gray.cgColor
        self.containerView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.containerView.layer.shadowOpacity = 0.3
        self.containerView.layer.shadowRadius = 2
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
    
    func handleStatistics() {
        self.percentualAdmonishmentLabel.isHidden = !self.showStatistics || self.showWeightedAttendance
        self.percentualAttendanceLabel.isHidden = !self.showStatistics || self.showWeightedAttendance
        if let rankingAttendance = self.rankingAttendance, self.showStatistics, !self.showWeightedAttendance {
            DispatchQueue.main.async {
                self.percentualAttendanceLabel.text = self.createAttendancePercentagesString(
                    rankingAttendance.attendanceNumber,
                    rankingAttendance.possibleAttendanceNumber)
                self.percentualAdmonishmentLabel.text = self.createAttendancePercentagesString(
                    rankingAttendance.admonishmentNumber,
                    rankingAttendance.possibleAttendanceNumber)
            }
        }
    }
    
    func createAttendancePercentagesString(_ numberOfPresence: Int, _ numberOfPossibleAttendance: Int) -> String {
        let numberOfPresenceDouble = Double(numberOfPresence)
        let numberOfPossibleAttendanceDouble = Double(numberOfPossibleAttendance)
        if numberOfPossibleAttendance != 0 {
            let percental = (numberOfPresenceDouble / numberOfPossibleAttendanceDouble) * 100
            let percentalString = String(format: "%.0f", percental)
            
            return "\(percentalString)%"
        }
        return ""
    }
    
    // MARK: Handle Notification Center method
    @objc func didChangeShowStatistics(_: Notification) {
        self.showStatistics = UserDefaults.standard.bool(forKey: "showStatistics")
        self.handleStatistics()
    }
    
    @objc func didChangeWeightedAttendance(_: Notification) {
        self.showWeightedAttendance = UserDefaults.standard.bool(forKey: "weightedAttendance")
        if self.rankingAttendance != nil, rankingType != nil  {
            self.attendanceLabel.text = self.getStringOfAttendanceLabel(self.rankingAttendance!, self.rankingType!)
        }
        self.percentualAdmonishmentLabel.isHidden = self.showWeightedAttendance ? true : false
        self.percentualAttendanceLabel.isHidden = self.showWeightedAttendance ? true : false
    }

}

