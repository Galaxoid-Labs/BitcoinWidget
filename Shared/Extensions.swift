//
//  Extensions.swift
//  Extensions
//
//  Created by Jacob Davis on 8/18/21.
//

import Foundation
import SwiftUI

extension Double {
    
    func formatCurrencyAbreviation(currencyCode: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1
        
        var number: NSNumber
        switch self {
        case 1_000_000_000_000..<1_000_000_000_000_000:
            number = NSNumber(value: self / 1_000_000_000_000)
            formatter.positiveSuffix = "T"
            formatter.negativeSuffix = "T"
        case 1_000_000_000..<1_000_000_000_000:
            number = NSNumber(value: self / 1_000_000_000)
            formatter.positiveSuffix = "B"
            formatter.negativeSuffix = "B"
        case 1_000_000..<1_000_000_000:
            number = NSNumber(value: self / 1_000_000)
            formatter.positiveSuffix = "M"
            formatter.negativeSuffix = "M"
        case 10_000..<1_000_000:
            number = NSNumber(value: self / 1_000)
            formatter.positiveSuffix = "K"
            formatter.negativeSuffix = "K"
        default: // 1_000..<10_000:
            number = NSNumber(value: self)
            formatter.positiveSuffix = ""
            formatter.negativeSuffix = ""
        }
        
        return formatter.string(from: number)!
    }
    
    func formatAbreviation() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1
        
        var number: NSNumber
        switch self {
        case 1_000_000_000_000..<1_000_000_000_000_000:
            number = NSNumber(value: self / 1_000_000_000_000)
            formatter.positiveSuffix = "T"
            formatter.negativeSuffix = "T"
        case 1_000_000_000..<1_000_000_000_000:
            number = NSNumber(value: self / 1_000_000_000)
            formatter.positiveSuffix = "B"
            formatter.negativeSuffix = "B"
        case 1_000_000..<1_000_000_000:
            number = NSNumber(value: self / 1_000_000)
            formatter.positiveSuffix = "M"
            formatter.negativeSuffix = "M"
        case 10_000..<1_000_000:
            number = NSNumber(value: self / 1_000)
            formatter.positiveSuffix = "K"
            formatter.negativeSuffix = "K"
        default: // 1_000..<10_000:
            number = NSNumber(value: self)
            formatter.positiveSuffix = ""
            formatter.negativeSuffix = ""
        }
        
        return formatter.string(from: number)!
    }
    
}

extension Text {
    init(_ string: String, configure: ((inout AttributedString) -> Void)) {
        var attributedString = AttributedString(string) /// create an `AttributedString`
        configure(&attributedString) /// configure using the closure
        self.init(attributedString) /// initialize a `Text`
    }
}
