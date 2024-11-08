//
//  gy.swift
//  Bdc
//
//  Created by leobartowski on 25/10/24.
//

import UIKit

class EfficientLabelHandler {
    
    private var cachedText: String?
    private var cachedAttributedString: NSAttributedString?
    
    func setLabelTextForLineChart(_ label: UILabel, with text: String, lastWord: String, color: UIColor = Theme.avatarRed) {
    
        if text == self.cachedText {
            label.attributedText = self.cachedAttributedString
            return
        }
        let attributedText = NSMutableAttributedString(string: text)
        let lastWordAttributed = NSAttributedString(
            string: lastWord,
            attributes: [
                .foregroundColor: color,
                .font: UIFont.systemFont(ofSize: label.font.pointSize, weight: .heavy)
            ]
        )
        attributedText.append(lastWordAttributed)
        self.cachedText = text
        self.cachedAttributedString = attributedText
        label.attributedText = self.cachedAttributedString
    }
    
    func setLabelTextForSlotLineChart(_ label: UILabel, baseText: String, numberOfMorning: Int, numberOfAfternoon: Int) {
        
        let newText = "\(baseText)\n mattina: \(numberOfMorning), pomeriggio: \(numberOfAfternoon)"
        if newText == self.cachedText {
            label.attributedText = self.cachedAttributedString
            return
        }
        let attributedText = NSMutableAttributedString(string: "\(baseText)\nmattina: ")
        let morningText = "\(numberOfMorning)"
        let morningAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: Theme.morningLineColor,
            .font: UIFont.systemFont(ofSize: label.font.pointSize, weight: .heavy)
        ]
        attributedText.append(NSAttributedString(string: morningText, attributes: morningAttributes))
        attributedText.append(NSAttributedString(string: ", pomeriggio: "))
        let afternoonText = "\(numberOfAfternoon)"
        let afternoonAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: Theme.eveningLineColor,
            .font: UIFont.systemFont(ofSize: label.font.pointSize, weight: .heavy)
        ]
        attributedText.append(NSAttributedString(string: afternoonText, attributes: afternoonAttributes))
        self.cachedText = newText
        self.cachedAttributedString = attributedText
    
        label.attributedText = cachedAttributedString
    }
}
