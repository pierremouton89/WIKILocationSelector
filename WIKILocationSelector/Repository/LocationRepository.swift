//
//  LocationRepository.swift
//  WIKILocationSelector
//
//  Created by Pierre Mouton on 23/06/2023.
//

import Foundation


protocol LocationsRepository {
    func retrieveLocations() async throws -> [Location]
}

class LocationsRepositoryImplementation: LocationsRepository {
    private let locationService: LocationService
    
    init(locationService: LocationService){
        self.locationService = locationService
    }
    
    func retrieveLocations() async throws -> [Location] {
        return try await self.locationService.loadLocations().map { $0.location }
    }
}

extension LocationData {
    var location: Location {
        return .init(
            name: self.name,
            latitude: self.latitude,
            longitude: self.longitude
        )
    }
}
