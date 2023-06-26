//
//  LocationDisplayModel.swift
//  WIKILocationSelector
//
//  Created by Pierre Mouton on 26/06/2023.
//

import Foundation

struct LocationDisplayModel: Equatable {
    let name: String
    let latitudeDescription: String
    let latitude: String
    let longitudeDescription: String
    let longitude: String
    let location: Location
    
    init(latitudeDescription: String = "Latitude:", longitudeDescription: String = "Longitude:", location: Location) {
        if let name = location.name, !name.isEmpty {
            self.name = name
        } else {
            self.name = "Unknown"
        }
        self.latitudeDescription = latitudeDescription
        self.latitude = String(location.latitude)
        self.longitudeDescription = longitudeDescription
        self.longitude = String(location.longitude)
        self.location = location
    }
}
