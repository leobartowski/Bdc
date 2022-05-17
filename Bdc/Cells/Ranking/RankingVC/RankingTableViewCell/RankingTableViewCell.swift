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
    var showStatistics = false

    override func layoutSubviews() {
        self.containerView.layer.shadowPath = UIBezierPath(roundedRect: self.containerView.bounds, cornerRadius: 15).cgPath
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.showStatistics = UserDefaults.standard.bool(forKey: "showStatistics")
        NotificationCenter.default.addObserver(self, selector: #selector(self.didChangeShowStatistics(_:)), name: .didChangeShowStatistics, object: nil)
        self.mainImageView.layer.cornerRadius = self.mainImageView.frame.height / 2
    }
    
    // MARK: Handle Show Statistics
    @objc func didChangeShowStatistics(_: Notification) {
        self.showStatistics = UserDefaults.standard.bool(forKey: "showStatistics")
        self.handleStatistics()
    }

    func setUp(_ rankingAttendance: RankingPersonAttendance, _ indexPath: IndexPath, _ rankingType: RankingType) {
        self.indexPath = indexPath
        self.rankingAttendance = rankingAttendance
        self.setUpShadow()
        self.nameLabel.text = rankingAttendance.person.name
        self.attendanceLabel.text = String(rankingAttendance.attendanceNumber)
        self.admonishmentLabel.text = String(rankingAttendance.admonishmentNumber)
        self.handleStatistics()
        let imageString = CommonUtility.getProfileImageString(rankingAttendance.person)
        self.mainImageView.image = UIImage(named: imageString)
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
        self.percentualAdmonishmentLabel.isHidden = !self.showStatistics
        self.percentualAttendanceLabel.isHidden = !self.showStatistics
        if let rankingAttendance = self.rankingAttendance, self.showStatistics {
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

}

