//
//  SortingPositionAndType.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 30/11/21.
//

import Foundation

public class SortingPositionAndType {
    
    var sortingPosition: SortingPosition
    var sortingType: SortingType

    init(_ sortingPosition: SortingPosition, _ sortingType: SortingType) {
        self.sortingPosition = sortingPosition
        self.sortingType = sortingType
    }
}

public enum SortingPosition: Int {
    
    case name = 0
    case attendance = 1
    case admonishment = 2
}

public enum SortingType {
    
    case ascending
    case descending

    var symbol: String {
        switch self {
        case .ascending: // Freccia verso l'alto
            return "\u{25B2}"
        case .descending: // Freccia verso il basso
            return "\u{25BC}"
        }
    }
}
