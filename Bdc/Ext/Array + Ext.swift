//
//  Array + Ext.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 30/11/21.
//

import Foundation

// inspired by Paul Hudson
extension Array {
    
    func chunkedElements(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
