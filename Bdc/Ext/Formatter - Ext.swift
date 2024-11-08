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

    static let dayAndMonthFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateFormat = "dd/MM"
        return dateFormatter
    }()
    
    static let monthAndYearVerboseFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter
    }()
    
    static let creationDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateFormat = "dd/MM/yyyy 'alle' HH:mm:ss"
        return dateFormatter
    }()
    
    static let verboseMonthYear: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "it")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMMyyyy")
        return dateFormatter
    }()
    
    static let verboseYear: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "it")
        dateFormatter.setLocalizedDateFormatFromTemplate("yyyy")
        return dateFormatter
    }()
    
    static let smallYear: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateFormat = "yy"
        return dateFormatter
    }()

}
