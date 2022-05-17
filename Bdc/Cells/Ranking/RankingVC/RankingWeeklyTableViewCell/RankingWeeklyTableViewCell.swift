//
//  RankingTableViewCell.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 23/11/21.
//

import Foundation
import UIKit

class RankingWeeklyTableViewCell: UITableViewCell {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var mainImageView: UIImageView!
    @IBOutlet var attendanceLabel: UILabel!
    @IBOutlet var admonishmentLabel: UILabel!
    @IBOutlet var percentualAttendanceLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var percentualAdmonishmentLabel: UILabel!
    
    var indexPath = IndexPath()
    var rankingAttendance: RankingPersonAttendance?
    var showStatistics = false
    
    let days = ["L", "M", "M", "G", "V"]
    var morningDaysNumbers: [Int] = []
    var eveningDaysNumbers: [Int] = []
    var holidayDaysNumbers: [Int] = []
    
    var isDetailViewHidden: Bool {
        return self.collectionView.isHidden
    }
    
    override func layoutSubviews() {
        self.containerView.layer.shadowPath = UIBezierPath(roundedRect: self.containerView.bounds, cornerRadius: 15).cgPath
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.autoresizingMask = .flexibleHeight
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.isHidden = true
        self.collectionView.collectionViewLayout = self.setupCollectionViewLayout()
        self.mainImageView.layer.cornerRadius = self.mainImageView.frame.height / 2
        self.showStatistics = UserDefaults.standard.bool(forKey: "showStatistics")
        NotificationCenter.default.addObserver(self, selector: #selector(self.didChangeShowStatistics(_:)), name: .didChangeShowStatistics, object: nil)
    }
    
    private func setupCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 30, height: 30)
        layout.headerReferenceSize = CGSize(width: 50, height: 30)
        layout.footerReferenceSize = CGSize(width: 0, height: 0)
        // TODO: Improve minimumInteritemSpacing and itemSize to to align the letters with the calendar days (lun, mar, mer, ...)
        let minimumInteritemSpacing = (self.collectionView.frame.width - (layout.itemSize.width * 7)) / 7
        layout.minimumInteritemSpacing = CGFloat(minimumInteritemSpacing)
        layout.minimumLineSpacing = CGFloat(0)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return layout
    }
    
    func setUp(_ rankingAttendance: RankingPersonAttendance, _ indexPath: IndexPath, _ rankingType: RankingType, _ datesOfTheWeek: [Date]) {
        self.indexPath = indexPath
        self.rankingAttendance = rankingAttendance
        self.setUpShadow()
        self.nameLabel.text = rankingAttendance.person.name
        self.attendanceLabel.text = String(rankingAttendance.attendanceNumber)
        self.admonishmentLabel.text = String(rankingAttendance.admonishmentNumber)
        self.handleStatistics()
        let imageString = CommonUtility.getProfileImageString(rankingAttendance.person)
        self.mainImageView.image = UIImage(named: imageString)
        self.morningDaysNumbers = self.createNumbersArray(rankingAttendance.morningDate)
        self.eveningDaysNumbers = self.createNumbersArray(rankingAttendance.eveningDate)
        self.holidayDaysNumbers = self.createHoldayDatesNumberArray(datesOfTheWeek)
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
    
    // MARK: Handle Show Statistics
    @objc func didChangeShowStatistics(_: Notification) {
        self.showStatistics = UserDefaults.standard.bool(forKey: "showStatistics")
        self.handleStatistics()
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
    
    func handleShadowOnFriday(_ weekNumber: Int? = 0) {
        // Show red and green cell only on friday and only if the week on focus is the current week
        if Date().getDayNumberOfWeek() == 6, weekNumber == Date.now.getWeekNumber() {
            // Check if the user has at least two presence or more than 2 admonishment
            let attendance: Int = Int(attendanceLabel.text ?? "") ?? 0
            let admonishment: Int = Int(admonishmentLabel.text ?? "") ?? 0
            self.containerView.layer.shadowOpacity = 0.3
            self.containerView.layer.shadowColor = attendance < 2 || admonishment >= 2
            ? UIColor.red.cgColor
            : Theme.customGreen.cgColor
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
    
    func createHoldayDatesNumberArray(_ dates: [Date]) -> [Int] {
        var holidayDatesNumbers: [Int] = []
        for date in dates {
            if date.isHoliday(in: .italy) {
                holidayDatesNumbers.append(date.getDayNumberOfWeek() ?? 1)
            }
        }
        return holidayDatesNumbers
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
