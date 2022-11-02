//
//  UIApplication - Ext.swift
//  Bdc
//
//  Created by leobartowski on 31/10/22.
//

import Foundation
import UIKit

extension UIApplication {
    var isKeyboardPresented: Bool {
        if let keyboardWindowClass = NSClassFromString("UIRemoteKeyboardWindow"), self.windows.contains(where: { $0.isKind(of: keyboardWindowClass) }) {
            return true
        } else {
            return false
        }
    }
}
