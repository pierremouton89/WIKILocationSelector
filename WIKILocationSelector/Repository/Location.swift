//
//  Location.swift
//  WIKILocationSelector
//
//  Created by Pierre Mouton on 23/06/2023.
//

import Foundation

struct Location: Equatable, Encodable {
    let name: String?
    let latitude: Double
    let longitude: Double
    
    init(name: String? = nil, latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
    
}

