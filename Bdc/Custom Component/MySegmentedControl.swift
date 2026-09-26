//
//  MySegmentedControl.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 23/11/21.
//

import Foundation
import UIKit

class MySegmentedControl: UISegmentedControl {
    
    // Needed to remove the greyish background
    override func layoutSubviews() {
        super.layoutSubviews()
        // On iOS 26 the internal subviews changed and hiding them breaks the Liquid Glass look
        if #available(iOS 26, *) { return }

        for i in 0 ... (numberOfSegments - 1) {
            subviews[i].isHidden = true
        }
    }

    /// Native Liquid Glass look: system track and glass selection, only the selected title is tinted
    @available(iOS 26, *)
    func applyLiquidGlassStyle() {
        self.backgroundColor = nil
        self.selectedSegmentTintColor = nil
        self.layer.borderWidth = 0
        self.setTitleTextAttributes([.foregroundColor: Theme.main], for: .selected)
        self.setTitleTextAttributes([.foregroundColor: UIColor.secondaryLabel], for: .normal)
    }
}
