//
//  RankingTableViewCell.swift
//  Bdc
//
//  Created by leobartowski on 09/01/22.
//

import UIKit

protocol RankingTableViewCellDelegate: AnyObject {
    
    func cell(_ cell: RankingTableViewCell, didSelectNameLabelAt indexPath: IndexPath)
}

class RankingTableViewCell: UITableViewCell {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var nameButton: UIButton!
    @IBOutlet var mainImageView: UIImageView!
    @IBOutlet var attendanceLabel: UILabel!
    @IBOutlet var admonishmentLabel: UILabel!
    @IBOutlet var percentualAttendanceLabel: UILabel!
    @IBOutlet var percentualAdmonishmentLabel: UILabel!
    
    weak var delegate: RankingTableViewCellDelegate?
        
    var indexPath = IndexPath()
    var rankingAttendance: RankingPersonAttendance?
    var rankingType: RankingType?
    var showStatistics = false
    
    override func layoutSubviews() {
        self.containerView.layer.shadowPath = UIBezierPath(roundedRect: self.containerView.bounds, cornerRadius: 15).cgPath
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.showStatistics = UserDefaults.standard.bool(forKey: "showStatistics")
        NotificationCenter.default.addObserver(self, selector: #selector(self.didChangeShowStatistics(_:)), name: .didChangeShowStatistics, object: nil)
        // Design
        self.mainImageView.layer.cornerRadius = self.mainImageView.frame.height / 2
    }
    
    // MARK: SetUp
    func setUp(_ rankingAttendance: RankingPersonAttendance, _ indexPath: IndexPath, _ rankingType: RankingType, _ delegate: RankingTableViewCellDelegate) {
        self.delegate = delegate
        self.indexPath = indexPath
        self.rankingAttendance = rankingAttendance
        self.rankingType = rankingType
        self.setUpShadow()
        self.nameButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.nameButton.setUnderlinedTitle(rankingAttendance.person.name ?? "")
        self.attendanceLabel.text = self.getStringOfAttendanceLabel(rankingAttendance, rankingType)
        self.admonishmentLabel.text = String(rankingAttendance.admonishmentNumber)
        self.handleStatistics()
        let imageString = CommonUtility.getProfileImageString(rankingAttendance.person)
        self.mainImageView.image = UIImage(named: imageString)
    }
    
    func getStringOfAttendanceLabel(_ rankingAttendance: RankingPersonAttendance, _ rankingType: RankingType) -> String {
        if rankingType == .allTimePonderate {
            let number = Float(rankingAttendance.attendanceNumber) * rankingAttendance.person.difficultyCoefficient
            return String(format: "%.1f", number)
        } else {
            return String(rankingAttendance.attendanceNumber)
        }
    }
    
    func setUpShadow() {
        self.containerView.cornerRadius = 15
        self.containerView.layer.masksToBounds = true
        if self.traitCollection.userInterfaceStyle != .dark {
            self.containerView.addShadow(height: 0, opacity: 0.3)
        }
    }
    
    func setupLabelDesign(_ labelNumber: Int) {
        switch labelNumber {
        case 0:
            self.nameButton.setUnderlinedTitle(self.rankingAttendance?.person.name ?? "",
                                               font: .systemFont(ofSize: 19, weight: .medium))
            self.attendanceLabel.font = .systemFont(ofSize: 19, weight: .light)
            self.admonishmentLabel.font = .systemFont(ofSize: 19, weight: .light)
        case 1:
            self.nameButton.setUnderlinedTitle(self.rankingAttendance?.person.name ?? "")
            self.attendanceLabel.font = .systemFont(ofSize: 19, weight: .medium)
            self.admonishmentLabel.font = .systemFont(ofSize: 19, weight: .light)
        case 2:
            self.nameButton.setUnderlinedTitle(self.rankingAttendance?.person.name ?? "")
            self.attendanceLabel.font = .systemFont(ofSize: 19, weight: .light)
            self.admonishmentLabel.font = .systemFont(ofSize: 19, weight: .medium)
        default:
            break
        }
    }

    @IBAction func clickNameButton(_ sender: Any) {
        self.delegate?.cell(self, didSelectNameLabelAt: indexPath)
    }
    
    func handleStatistics() {
        
        self.percentualAdmonishmentLabel.isHidden = !self.showStatistics || self.rankingType == .allTimePonderate
        self.percentualAttendanceLabel.isHidden = !self.showStatistics || self.rankingType == .allTimePonderate
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
    
    // MARK: Handle Notification Center method
    @objc func didChangeShowStatistics(_: Notification) {
        self.showStatistics = UserDefaults.standard.bool(forKey: "showStatistics")
        self.handleStatistics()
    }
}
