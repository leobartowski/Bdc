//
//  IncrementableLabel.swift
//  Bdc
//
//  Created by leobartowski on 30/10/24.
//
import UIKit
import IncrementableLabel

extension StatisticsViewController {
    
    func setTextDividerLabels() {
        switch self.chartPeriodType {
        case .weekly:
            self.dividerLineChartLabel.text = "Andamento settimanale"
            self.dividerSlotLineChartLabel.text = "Andamento settimanale: mattina vs pomeriggio"
            self.dividerBarChartLabel.text = "Presenze totali per ciascun giorno della settimana"
        case .monthly:
            self.dividerLineChartLabel.text = "Andamento mensile"
            self.dividerSlotLineChartLabel.text = "Andamento mensile: mattina vs pomeriggio"
            self.dividerBarChartLabel.text = "Presenze totali per ciascun mese"
        case .yearly:
            self.dividerLineChartLabel.text = "Andamento annuale"
            self.dividerSlotLineChartLabel.text = "Andamento annuale: mattina vs pomeriggio"
            self.dividerBarChartLabel.text = ""
        }
    }
    
    func createLabels() {
        self.createTotalAttendanceLabel()
        self.createRatioMornignEveningLabel()
        if self.isIndividualStats {
            self.createBestStreakLabel()
            self.createBestPalsLabels()
        } else {
            self.createMaxNumberOfAttendanceLabel()
        }
    }
    
    func animateIncrementalLabels() {
        self.totalAttendanceLabel.incrementFromZero(toValue: Double(self.statsData.totalAttendance),
                                                    duration: incrementaLabelAnimationDuration)
        self.secondStatsLabel.incrementFromZero(toValue: self.isIndividualStats
                                                             ? Double(self.statsData.bestStreak.count)
                                                             :  Double(self.statsData.maxDay.nOfAtt),
                                                             duration: incrementaLabelAnimationDuration)
    }
    
    func createAndAnimateGrowthLabel() {
        let growth = self.chartPeriodHelper.getStats(with: self.statsData)
        let isGrowthPositive = growth >= 0
        let color: UIColor = isGrowthPositive ? .systemGreen : .systemRed
        let basicText = self.chartPeriodHelper.labelsForGrowrth(isGrowthPositive)
        IncrementableLabelHelper.createWithValueInTheMiddle(for: self.periodGrowthLabel,
                                                            startText: basicText.start,
                                                            endText: basicText.end,
                                                            numberFontColor: color)
        self.periodGrowthLabel.incrementFromZero(toValue: abs(growth), duration: incrementaLabelAnimationDuration)
    }
    
    fileprivate func createBestPalsLabels() {
        if self.statsData.bestPals.count >= 2 {
            let palsEmojis = ["🥇", "🥈", "🥉"]
            self.firstPalLabel.text = "\(palsEmojis[0]) " + self.statsData.bestPals[0].key + " con \(self.statsData.bestPals[0].value) presenze"
            self.secondPalLabel.text = "\(palsEmojis[1]) " + self.statsData.bestPals[1].key + " con \(self.statsData.bestPals[1].value) presenze"
            self.thirdPalLabel.text = "\(palsEmojis[2]) " + self.statsData.bestPals[2].key + " con \(self.statsData.bestPals[2].value) presenze"
        }
    }
    
    fileprivate func createTotalAttendanceLabel() {
        if self.isIndividualStats {
            IncrementableLabelHelper.createWithValueInTheMiddle(for: self.totalAttendanceLabel,
                                                                startText: "Ha ",
                                                                endText: " presenze, \(self.statsData.totalAttendanceMorning) la mattina e \(self.statsData.totalAttendanceEvening) \nil pomeriggio",
                                                                formatValue: "%.0f")
        } else {
            IncrementableLabelHelper.createWithValueInTheMiddle(for: self.totalAttendanceLabel,
                                                                startText: "Siamo scesi ",
                                                                endText: " volte!",
                                                                formatValue: "%.0f")
        }
    }
    
    fileprivate func createBestStreakLabel() {
        IncrementableLabelHelper.createWithValueInTheMiddle(for: self.secondStatsLabel,
                                                            startText: "Miglior serie di giorni con almeno una presenza: ",
                                                            endText: " dal \(self.statsData.bestStreak.beginDate) al \(self.statsData.bestStreak.endDate)",
                                                            formatValue: "%.0f")
    }
    
    fileprivate func createMaxNumberOfAttendanceLabel() {
        IncrementableLabelHelper.createWithValueInTheMiddleCustom(for: self.secondStatsLabel,
                                                                  startText: "Il nostro miglior giorno è stato il ",
                                                                  endText: " presenze",
                                                                  dateText: self.statsData.maxDay.dateString)
        
    }
    
    fileprivate func createRatioMornignEveningLabel() {
        let ratioText = self.createRatioMornignEveningLabelText()
        if ratioText.ratio != 0 {
            IncrementableLabelHelper.createWithValueInTheMiddle(for: self.ratioMorningEveningLabel,
                                                                startText: ratioText.startText,
                                                                endText: ratioText.endText,
                                                                formatValue: "%.2f")
            self.ratioMorningEveningLabel.incrementFromZero(toValue: ratioText.ratio,
                                                            duration: incrementaLabelAnimationDuration)
        } else {
            self.ratioMorningEveningLabel.text = ratioText.startText
        }
    }
    
    fileprivate func createRatioMornignEveningLabelText() -> (startText: String, endText: String, ratio: Double) {
        if self.statsData.totalAttendanceEvening == 0 {
            return ("Non ci sono presenze di pomeriggio, impossibile confrontare", "", 0)
        }
        if self.statsData.totalAttendanceMorning == 0 {
            return ("Non ci sono presenze di mattina, impossibile confrontare", "", 0)
        }
        let ratio = Double(self.statsData.totalAttendanceEvening) / Double(self.statsData.totalAttendanceMorning)
        if ratio > 1 {
            return ("Il numero di presenze di pomeriggio è circa ", " volte superiore a quelle di mattina", ratio)
        } else if ratio < 1 {
            let invertedRatio = pow(ratio, -1)
            return ("Il numero di presenze di mattina è circa ", " volte superiore a quelle di pomeriggio", invertedRatio)
        } else {
            return ("Il numero di presenze di mattina è ugale a quelle del pomeriggio", "", 0)
        }
    }
}
