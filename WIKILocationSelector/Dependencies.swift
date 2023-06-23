//
//  Dependencies.swift
//  WIKILocationSelector
//
//  Created by Pierre Mouton on 23/06/2023.
//

import Foundation

class Dependencies {
    
    static let shared = Dependencies()
    private init() {
    }
    
    var locationsRepository: LocationsRepository {
        return LocationsRepositoryImplementation(locationService: self.locationService)
    }
    

    var locationService: LocationService {
        return LocationServiceImplementation(httpClient: URLSessionHTTPClient())
    }
}
