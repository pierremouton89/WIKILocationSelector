//
//  LocationData.swift
//  WIKILocationSelector
//
//  Created by Pierre Mouton on 23/06/2023.
//

import Foundation

struct LocationData: Equatable, Decodable {
        
    let name: String?
    let latitude: Double
    let longitude: Double
    enum CodingKeys: String, CodingKey {
        case name
        case latitude = "lat"
        case longitude = "long"
    }
}
