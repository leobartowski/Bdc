//
//  Label - Ext.swift
//  Bdc
//
//  Created by leobartowski on 09/01/22.
//

import UIKit

extension UILabel {
    /// Strikes through diagonally
    /// - Parameters:
    /// - offsetPercent: Improve visual appearance or flip line completely by passing a value between 0 and 1
    func diagonalStrikeThrough(offsetPercent: CGFloat = 0, riduceDimensionBy dim: CGFloat = 5) {
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: dim, y: bounds.height * (1 - offsetPercent) - dim))
        linePath.addLine(to: CGPoint(x: bounds.width - dim, y: bounds.height * offsetPercent + dim))

        let lineLayer = CAShapeLayer()
        lineLayer.path = linePath.cgPath
        lineLayer.lineWidth = 1
        lineLayer.strokeColor = textColor.cgColor
        layer.addSublayer(lineLayer)
    }
}
