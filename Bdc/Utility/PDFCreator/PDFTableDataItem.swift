//
//  PDFTableDataItem.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 30/11/21.
//

import Foundation

struct PDFTableDataItem {
    
    let personName: String
    let attendanceNumber: String
    let admonishmentNumber: String

    init(name: String, attendanceNumber: String, admonishmentNumber: String) {
        personName = name
        self.attendanceNumber = attendanceNumber
        self.admonishmentNumber = admonishmentNumber
    }
}
