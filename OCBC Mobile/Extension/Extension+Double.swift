//
//  Extension+Double.swift
//  OCBC Mobile
//
//  Created by Paninti Duta Internusa on 01/01/22.
//

import Foundation

extension Double {
    
    func priceFormatter() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.currencySymbol = "SGD "
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.currencyDecimalSeparator = "."
        numberFormatter.currencyGroupingSeparator = ","
        let priceStr = numberFormatter.string(from: NSNumber(value: self))
        return priceStr ?? "SGD 0"
    }
    
}
