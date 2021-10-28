//
//  Formatter - Ext.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 22/10/21.
//

import Foundation

extension Formatter {
    
    static let basicFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter
    }()
}

