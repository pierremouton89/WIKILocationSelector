//
//  DecimalInputStringFormatter.swift
//  WIKILocationSelector
//
//  Created by Pierre Mouton on 26/06/2023.
//

import Foundation

class DecimalInputStringFormatter {

    func whileEditing(format decimalValue: String, decimalSeparator: String = String.decimalSeparator) -> String {
        let filterOptions: String = "0123456789\(decimalSeparator)"
        let sanitisedDash: String = decimalValue.first == "-" ? "-" : ""
        let filterdDecimal = decimalValue.filter(filterOptions.contains)
        let decimalOnly = "\(sanitisedDash)\(filterdDecimal)"
        if decimalOnly.isEmpty {
            return ""
        }
        if filterdDecimal == "0" {
            return decimalOnly
        }
        let numbers = decimalOnly.components(separatedBy: String.decimalSeparator)
        let firstNumber = numbers.first ?? "0"
        let sanitesedFirstNumber = firstNumber.isEmpty ? "" : firstNumber
        guard decimalOnly.contains(decimalSeparator) else {
            return "\(sanitesedFirstNumber)"
        }
        return "\(sanitesedFirstNumber)\(decimalSeparator)\(numbers.suffix(from: 1).joined(separator:""))"
    }
    
    func whenDoneEditing(format decimalValue: String, decimalSeparator: String = String.decimalSeparator) -> String {
        guard !decimalValue.isEmpty else {
            return ""
        }
        return Decimal(string:decimalValue.trimmingCharacters(in: CharacterSet(charactersIn: String.decimalSeparator)))?.description  ?? "0"
    }
    
}
