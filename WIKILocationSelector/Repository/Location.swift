//
//  Location.swift
//  WIKILocationSelector
//
//  Created by Pierre Mouton on 23/06/2023.
//

import Foundation

struct Location: Equatable, Encodable {
    let name: String?
    let latitude: Decimal
    let longitude: Decimal
    
    init(name: String? = nil, latitude: Decimal, longitude: Decimal) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
    
}

