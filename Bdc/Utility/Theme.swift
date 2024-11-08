//
//  MainTheme.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 29/10/21.
//

import UIKit

enum Theme {
    
    static let black: UIColor = {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ?
            UIColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 1) :
            UIColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 1)
        }
    }()
    
    static let white: UIColor = {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ?
            UIColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 1) :
            UIColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 1)
        }
    }()
    
    // Main Color (Green in Light Mode, Adjusted for Dark Mode)
    static let mainColor: UIColor = {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ?
            UIColor(red: 0 / 255, green: 204 / 255, blue: 204 / 255, alpha: 1) :
            UIColor(red: 0 / 255, green: 128 / 255, blue: 128 / 255, alpha: 1)
        }
    }()
    
    // Custom Red
    static let customRed: UIColor = {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ?
            UIColor(red: 255 / 255, green: 94 / 255, blue: 50 / 255, alpha: 1) :
            UIColor(red: 255 / 255, green: 64 / 255, blue: 10 / 255, alpha: 1)
        }
    }()
    
    // Custom Yellow
    static let customYellow: UIColor = {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ?
            UIColor(red: 255 / 255, green: 255 / 255, blue: 140 / 255, alpha: 0.75) :
            UIColor(red: 255 / 255, green: 255 / 255, blue: 102 / 255, alpha: 0.75)
        }
    }()
    
    // Custom Green
    static let customGreen: UIColor = {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ?
            UIColor(red: 50 / 255, green: 230 / 255, blue: 140 / 255, alpha: 1) :
            UIColor(red: 17 / 255, green: 187 / 255, blue: 85 / 255, alpha: 1)
        }
    }()
    
    // Custom Light Red
    static let customLightRed: UIColor = {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ?
            UIColor(red: 255 / 255, green: 94 / 255, blue: 50 / 255, alpha: 0.5) :
            UIColor(red: 230 / 255, green: 64 / 255, blue: 10 / 255, alpha: 0.5)   
        }
    }()
    
    // Custom Medium Red
    static let customMediumRed: UIColor = {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ?
            UIColor(red: 255 / 255, green: 94 / 255, blue: 50 / 255, alpha: 0.75) :
            UIColor(red: 230 / 255, green: 64 / 255, blue: 10 / 255, alpha: 0.75)
        }
    }()
    
    // Custom Medium Green
    static let customMediumGreen: UIColor = {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ?
            UIColor(red: 50 / 255, green: 230 / 255, blue: 140 / 255, alpha: 0.75) :
            UIColor(red: 17 / 255, green: 187 / 255, blue: 85 / 255, alpha: 0.75)
        }
    }()
    
    // Dirty White
    static let dirtyWhite: UIColor = {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ?
            UIColor(red: 41 / 255, green: 41 / 255, blue: 41 / 255, alpha: 1) :
            UIColor(red: 250 / 255, green: 250 / 255, blue: 250 / 255, alpha: 1)
        }
    }()
    
    // Background Gray for Ranking
    static let backgroundGrayRanking: UIColor = {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ?
            UIColor(named: "4A4A4A") ?? UIColor(white: 74 / 255, alpha: 1) :
            UIColor(named: "9A9A9A") ?? UIColor(white: 154 / 255, alpha: 1)
        }
    }()
    
    // Pullbar Grey
    static let pullbarGrey: UIColor = {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ?
            UIColor(red: 100 / 255, green: 100 / 255, blue: 100 / 255, alpha: 1) :
            UIColor(red: 193 / 255, green: 193 / 255, blue: 193 / 255, alpha: 1)
        }
    }()
    
    // Avatar Red
    static let avatarRed: UIColor = {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ?
            UIColor(red: 255 / 255, green: 100 / 255, blue: 130 / 255, alpha: 1) :
            UIColor(red: 250 / 255, green: 53 / 255, blue: 78 / 255, alpha: 1)
        }
    }()
    
    // Avatar Light Red
    static let avatarLightRed: UIColor = {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ?
            UIColor(red: 255 / 255, green: 100 / 255, blue: 130 / 255, alpha: 0.2) :
            UIColor(red: 250 / 255, green: 53 / 255, blue: 78 / 255, alpha: 0.2)
        }
    }()
    
    // Avatar Black
    static let avatarBlack: UIColor = {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ?
            UIColor(red: 200 / 255, green: 200 / 255, blue: 205 / 255, alpha: 1) :
            UIColor(red: 51 / 255, green: 51 / 255, blue: 60 / 255, alpha: 1)
        }
    }()
    
    // FSCalendar Standard Light Selection Color
    static let FSCalendarStandardLightSelectionColor: UIColor = {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ?
            UIColor(red: 0 / 255, green: 204 / 255, blue: 204 / 255, alpha: 0.2) :
            UIColor(red: 0 / 255, green: 128 / 255, blue: 128 / 255, alpha: 0.2)
        }
    }()
    
    // FSCalendar Standard Today Color
    static let FSCalendarStandardTodayColor = avatarRed
    
    // FSCalendar Standard Title Text Color
    static let FSCalendarStandardTitleTextColor: UIColor = {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ?
            UIColor(red: 100 / 255, green: 160 / 255, blue: 255 / 255, alpha: 1.0) :
            UIColor(red: 14 / 255, green: 69 / 255, blue: 221 / 255, alpha: 1.0)
        }
    }()
    
    // FSCalendar Standard Event Dot Color
    static let FSCalendarStandardEventDotColor: UIColor = {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ?
            UIColor(red: 100 / 255, green: 180 / 255, blue: 255 / 255, alpha: 0.75) :
            UIColor(red: 31 / 255, green: 119 / 255, blue: 219 / 255, alpha: 0.75)
        }
    }()
    
    static let morningLineColor: UIColor = {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ?
            UIColor(red: 255 / 255, green: 139 / 255, blue: 172 / 255, alpha: 1) :
            UIColor(red: 192 / 255, green: 89 / 255, blue: 125 / 255, alpha: 1)
        }
    }()

    // Evening Line and Marker Color
    static let eveningLineColor: UIColor = {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ?
            UIColor(red: 85 / 255, green: 172 / 255, blue: 227 / 255, alpha: 1) :
            UIColor(red: 44 / 255, green: 124 / 255, blue: 178 / 255, alpha: 1)
        }
    }()
}
