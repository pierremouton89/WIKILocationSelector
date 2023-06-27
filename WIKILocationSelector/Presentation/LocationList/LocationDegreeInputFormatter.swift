//
//  LocationDegreeInputFormatter.swift
//  WIKILocationSelector
//
//  Created by Pierre Mouton on 26/06/2023.
//

import Foundation

struct LocationDegreeBounds:Equatable {
    let max: Double
    let min: Double
    
    static var latitude: Self {
        return .init(max: 90, min: -90)
    }
    static var longitude: Self {
        return .init(max: 180, min: -180)
    }
}

class LocationDegreeInputFormatter {

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
    
    
    func whenDoneEditing(format decimalValue: String, decimalSeparator: String = String.decimalSeparator, degreeBounds: LocationDegreeBounds) -> String {
        guard !decimalValue.isEmpty else {
            return ""
        }
        
        let value = Double(decimalValue) ?? 0
        if value == 0 {
            return "0"
        }
        let formatter = NumberFormatter.degreeNumberFormatter
        let sanitisedValue: Double
        if value > degreeBounds.max {
            sanitisedValue = degreeBounds.max
        } else if value < degreeBounds.min {
            sanitisedValue = degreeBounds.min
        } else {
            sanitisedValue = value
        }
        return formatter.string(from: NSNumber(value: sanitisedValue)) ?? "0"
    }
    
}

extension NumberFormatter {
    static let degreeNumberFormatter: NumberFormatter =  {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 6
        numberFormatter.minimumFractionDigits = 0
        return numberFormatter
    }()
}
