//
//  UIView - Ext.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 20/11/21.
//

import Foundation
import UIKit

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }

    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: width)
        layer.addSublayer(border)
    }

    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: frame.size.width - width, y: 0, width: width, height: frame.size.height)
        layer.addSublayer(border)
    }

    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: frame.size.height - width, width: frame.size.width, height: width)
        layer.addSublayer(border)
    }

    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: frame.size.height)
        layer.addSublayer(border)
    }
    
    func hideViewWithTransition(hidden: Bool, duration: CGFloat = 0.5) {
        UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: {
            self.isHidden = hidden
        })
    }
    
    func addShadow(_ color: UIColor = .systemGray,
                   height: Double = 4,
                   opacity: Float = 0.2,
                   shadowRadius: CGFloat = 2) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: height)
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = shadowRadius
        self.layer.masksToBounds = false
    }
    
    func removeShadow() {
        if self.layer.shadowOpacity != 0 {
            self.layer.shadowOffset = CGSize(width: 0.0, height: 0)
            self.layer.shadowOpacity = 0
            self.layer.shadowRadius = 0
            self.layer.masksToBounds = true
        }
    }
}
