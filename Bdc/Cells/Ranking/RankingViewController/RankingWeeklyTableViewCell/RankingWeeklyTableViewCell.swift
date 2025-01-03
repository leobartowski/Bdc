//
//  RankingTableViewCell.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 23/11/21.
//

import Foundation
import UIKit

protocol RankingWeeklyTableViewCellDelegate: AnyObject {
    
    func cell(_ cell: RankingWeeklyTableViewCell, didSelectNameLabelAt indexPath: IndexPath)
}

class RankingWeeklyTableViewCell: UITableViewCell {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var nameButton: UIButton!
    @IBOutlet var mainImageView: UIImageView!
    @IBOutlet var attendanceLabel: UILabel!
    @IBOutlet var admonishmentLabel: UILabel!
    @IBOutlet var percentualAttendanceLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var percentualAdmonishmentLabel: UILabel!
    
    weak var delegate: RankingWeeklyTableViewCellDelegate?

    var indexPath = IndexPath()
    var rankingAttendance: RankingPersonAttendance?
    var showStatistics = false
    
    let days = ["L", "M", "M", "G", "V"]
    var morningDaysNumbers: [Int] = []
    var eveningDaysNumbers: [Int] = []
    var morningDaysAdmonishmentNumbers: [Int] = []
    var eveningDaysAdmonishmentNumbers: [Int] = []
    var holidayDaysNumbers: [Int] = []
    
    var isDetailViewHidden: Bool {
        return self.collectionView.isHidden
    }
    
    override func layoutSubviews() {
//        self.containerView.layer.shadowPath = UIBezierPath(roundedRect: self.containerView.bounds, cornerRadius: 15).cgPath
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.autoresizingMask = .flexibleHeight
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.isHidden = true
        self.collectionView.collectionViewLayout = self.setupCollectionViewLayout()
        self.mainImageView.layer.cornerRadius = self.mainImageView.frame.height / 2
        self.showStatistics = UserDefaults.standard.bool(forKey: SettingsType.showPercentageInRanking.rawValue)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didChangeShowStatistics(_:)), name: .didChangeShowPercentageInRanking, object: nil)
    }
    
    private func setupCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 30, height: 30)
        layout.headerReferenceSize = CGSize(width: 50, height: 30)
        layout.footerReferenceSize = CGSize(width: 0, height: 0)
        let minimumInteritemSpacing = (self.collectionView.frame.width - (layout.itemSize.width * 7)) / 7
        layout.minimumInteritemSpacing = CGFloat(minimumInteritemSpacing)
        layout.minimumLineSpacing = CGFloat(0)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return layout
    }
    
    func setUp(_ rankingAttendance: RankingPersonAttendance, _ indexPath: IndexPath, _ rankingType: RankingType, _ holidaysNumbers: [Int], _ delegate: RankingWeeklyTableViewCellDelegate) {
        self.delegate = delegate
        self.indexPath = indexPath
        self.rankingAttendance = rankingAttendance
        self.setUpDesign()
        self.nameButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.nameButton.setUnderlinedTitle(rankingAttendance.person.name ?? "")
        self.attendanceLabel.text = String(rankingAttendance.attendanceNumber)
        self.admonishmentLabel.text = String(rankingAttendance.admonishmentNumber)
        self.morningDaysAdmonishmentNumbers = self.createNumbersArray(rankingAttendance.morningAdmonishmentDate)
        self.eveningDaysAdmonishmentNumbers = self.createNumbersArray(rankingAttendance.eveningAdmonishmentDate)
        self.morningDaysNumbers = self.createNumbersArray(rankingAttendance.morningDate)
        self.eveningDaysNumbers = self.createNumbersArray(rankingAttendance.eveningDate)
        self.holidayDaysNumbers = holidaysNumbers
        self.handleStatistics()
        let imageString = CommonUtility.getProfileImageString(rankingAttendance.person)
        self.mainImageView.image = UIImage(named: imageString)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if self.isDetailViewHidden, selected {
            self.collectionView.isHidden = false
        } else {
            self.collectionView.isHidden = true
        }
        contentView.layoutIfNeeded()
        contentView.updateConstraints()
        contentView.layoutIfNeeded()
        setNeedsLayout()
    }
    
    @IBAction func clickNameButton(_ sender: Any) {
        self.delegate?.cell(self, didSelectNameLabelAt: indexPath)
    }
    
    // MARK: Handle Show Statistics
    @objc func didChangeShowStatistics(_: Notification) {
        self.showStatistics = UserDefaults.standard.bool(forKey: SettingsType.showPercentageInRanking.rawValue)
        self.handleStatistics()
    }

    func setUpDesign() {
        self.containerView.layer.borderWidth = 0
        self.containerView.cornerRadius = 15
        self.containerView.layer.masksToBounds = true
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
    /// Show red and green cell only on friday, saturday and sunday and only if the week on focus is the current week
    func handleBorderColorForHighlight() {
        let attendance = self.rankingAttendance?.attendanceNumber ?? 0
        let admonishment = self.rankingAttendance?.admonishmentNumber ?? 0
        self.containerView.layer.borderWidth = 1
        self.containerView.layer.borderColor = attendance < 2 || admonishment >= 3
        ? UIColor.systemRed.cgColor
        : Theme.customGreen.cgColor
        
    }
    
    // Given an array of date create an array of Int that represents the specifc number of the day in the weel
    func createNumbersArray(_ dates: [Date]) -> [Int] {
        var datesNumbers: [Int] = []
        for date in dates {
            datesNumbers.append(date.getDayNumberOfWeek() ?? 1)
        }
        return datesNumbers
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
