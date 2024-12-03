//
//  UIButton - Ext.swift
//  Bdc
//
//  Created by leobartowski on 10/11/24.
//

import UIKit

extension UIButton {
    
    func setUnderlinedTitle(_ title: String, color: UIColor = .label, font: UIFont = .systemFont(ofSize: 19, weight: .light)) {
        var attributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .foregroundColor: color
        ]
        attributes[.font] = font
        attributes[.underlineColor] = color
        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        UIView.performWithoutAnimation {
            self.setAttributedTitle(attributedTitle, for: .normal)
            self.layoutIfNeeded()
        }
    }    
}
