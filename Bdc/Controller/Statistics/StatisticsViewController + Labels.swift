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
        self.createMaxNumberOfAttendanceLabel()
        self.createRatioMornignEveningLabel()
    }
    
    func animateIncrementalLabels() {
        self.totalAttendanceLabel.incrementFromZero(toValue: Double(self.statsData.totalAttendance),
                                                    duration: incrementaLabelAnimationDuration)
        self.dayMaxNumberOfAttendanceLabel.incrementFromZero(toValue:
                                                                Double(self.statsData.maxDay.nOfAtt),
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
    
    fileprivate func createTotalAttendanceLabel() {
        IncrementableLabelHelper.createWithValueInTheMiddle(for: self.totalAttendanceLabel, startText: "Siamo scesi ", endText: " volte!", formatValue: "%.0f")

    }
    
    fileprivate func createMaxNumberOfAttendanceLabel() {
        IncrementableLabelHelper.createWithValueInTheMiddleCustom(for: self.dayMaxNumberOfAttendanceLabel,
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
