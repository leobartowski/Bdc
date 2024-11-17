//
//  IncrementableLabelHelper.swift
//  Bdc
//
//  Created by leobartowski on 31/10/24.
//
import Foundation
import IncrementableLabel

class IncrementableLabelHelper {
    
    static func createWithValueAtEnd(for label: IncrementableLabel,
                                     baseText: String,
                                     numberFontColor: UIColor = Theme.main,
                                     numberFontSize: CGFloat = 17,
                                     numberFontWeight: UIFont.Weight = .heavy) {
        label.attributedTextFormatter = { value in
            let value = String(format: "%.0f", value)
            let valueAttributed = NSAttributedString(
                string: value,
                attributes: [
                    .foregroundColor: numberFontColor,
                    .font: UIFont.systemFont(ofSize: numberFontSize, weight: numberFontWeight)
                ]
            )
            let attributedText = NSMutableAttributedString(string: baseText + " ")
            attributedText.append(valueAttributed)
            return attributedText
        }
    }
    
    static func createWithValueInTheMiddle(for label: IncrementableLabel,
                                           startText: String,
                                           endText: String,
                                           formatValue: String = "%.0f%%",
                                           numberFontColor: UIColor = Theme.main,
                                           numberFontSize: CGFloat = 17,
                                           numberFontWeight: UIFont.Weight = .heavy) {
        label.attributedTextFormatter = { value in
            
            let value = String(format: formatValue, value)
            let valueAttributed = NSAttributedString(
                string: value,
                attributes: [
                    .foregroundColor: numberFontColor,
                    .font: UIFont.systemFont(ofSize: numberFontSize, weight: numberFontWeight)
                ]
            )
            let attributedText = NSMutableAttributedString(string: startText)
            attributedText.append(valueAttributed)
            attributedText.append(NSAttributedString(string: endText))
            return attributedText
        }
    }
    
    static func createWithValueInTheMiddleCustom(for label: IncrementableLabel,
                                                 startText: String,
                                                 endText: String,
                                                 dateText: String,
                                                 numberFontColor: UIColor = Theme.main,
                                                 numberFontSize: CGFloat = 17,
                                                 numberFontWeight: UIFont.Weight = .heavy) {
        label.attributedTextFormatter = { value in
            
            let value = String(format: "%.0f", value)
            let valueAttributed = NSAttributedString(
                string: value,
                attributes: [
                    .foregroundColor: numberFontColor,
                    .font: UIFont.systemFont(ofSize: numberFontSize, weight: numberFontWeight)
                ]
            )
            let attributedText = NSMutableAttributedString(string: startText)
            let dateTextAttributed = NSAttributedString(
                string: dateText,
                attributes: [
                    .foregroundColor: numberFontColor,
                    .font: UIFont.systemFont(ofSize: numberFontSize, weight: numberFontWeight)
                ]
            )
            attributedText.append(dateTextAttributed)
            attributedText.append(NSAttributedString(string: " con "))
            attributedText.append(valueAttributed)
            attributedText.append(NSAttributedString(string: endText))
            return attributedText
        }
    }
}
