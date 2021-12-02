//
//  RankingViewController + PDF.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 30/11/21.
//

import Foundation
import PDFKit

extension RankingViewController: UIActivityItemSource {
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return "The pig is in the poke"
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return "The pig is in the poke"
    }
    

    func createPDF(_ pdfTitle: String) -> Data {
        let pdfPersonsAttendaces = self.rankingPersonsAttendaces.sorted { $0.attendanceNumber > $1.attendanceNumber }
        var tableDataItems = [PDFTableDataItem]()
        for personAttendances in pdfPersonsAttendaces {
            tableDataItems.append(PDFTableDataItem(
                name: personAttendances.person.name ?? "---",
                attendanceNumber: String(personAttendances.attendanceNumber) ,
                admonishmentNumber: String(personAttendances.admonishmentNumber)
            ))
        }
        let tableDataHeaderTitles =  ["Nome", "Presenze", "Ammonizioni"]
        let pdfCreator = PDFCreator(tableDataItems: tableDataItems, tableDataHeaderTitles: tableDataHeaderTitles, pdfTitle: pdfTitle)
        let data = pdfCreator.create()
        return data
    }

}
