//
//  CommonUtility.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 25/10/21.
//

import Foundation

class CommonUtility {
    
    public static func getProfileImageString(_ person: Person?) -> String {
        if let personIconString = person?.iconString {
            return personIconString
        }
        let femaleName = ["Mary", "Lisa", "Giannetta", "Raffaella", "Alessia", "Angela"]
        return femaleName.contains(person?.name ?? "") ? "woman_placeholder_icon" : "man_placeholder_icon"
    }
}
