//
//  RankingViewController + PDF.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 30/11/21.
//

import Foundation
import PDFKit

extension RankingViewController {
    
    func createPDF(_ pdfTitle: String) -> Data {
        
        var tableDataItems = [PDFTableDataItem]()
        
        for personAttendances in self.rankingPersonsAttendaces {
            tableDataItems.append(PDFTableDataItem(
                name: personAttendances.person.name ?? "---",
                attendanceNumber: self.getStringOfAttendanceLabel(personAttendances),
                admonishmentNumber: String(personAttendances.admonishmentNumber)
            ))
        }
        tableDataItems = tableDataItems.sorted { (Float($0.attendanceNumber) ?? 0) > (Float($1.attendanceNumber) ?? 0) }
        let tableDataHeaderTitles = ["Nome", "Presenze", "Ammonizioni"]
        let pdfCreator = PDFCreator(
            tableDataItems: tableDataItems,
            tableDataHeaderTitles: tableDataHeaderTitles,
            pdfTitle: pdfTitle,
            rankingType: self.rankingType
        )
        let data = pdfCreator.create()
        return data
    }
    
    func getStringOfAttendanceLabel(_ rankingAttendance: RankingPersonAttendance) -> String {
        if self.rankingType == .allTimePonderate {
            let number = Float(rankingAttendance.attendanceNumber) * rankingAttendance.person.difficultyCoefficient
            return String(format: "%.1f", number)
        } else {
            return String(rankingAttendance.attendanceNumber)
        }
    }
}
