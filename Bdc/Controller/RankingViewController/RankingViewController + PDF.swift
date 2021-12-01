//
//  RankingViewController + PDF.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 30/11/21.
//

import Foundation
import PDFKit

extension RankingViewController {
    
    func createUI(pdfView: PDFView) {
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pdfView)
        pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        pdfView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
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
