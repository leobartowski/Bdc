//
//  TimeInterval - Ext.swift
//  Bdc
//
//  Created by leobartowski on 02/11/24.
//
import Foundation

extension TimeInterval {
    
    func getString() -> String {
        let time = NSInteger(self)
        let mills = Int((self.truncatingRemainder(dividingBy: 1)) * 1000)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        return String(format: "%0.2d:%0.2d:%0.2d.%0.3d", hours, minutes, seconds, mills)
    }
}
