//
//  LocationService.swift
//  WIKILocationSelector
//
//  Created by Pierre Mouton on 23/06/2023.
//

import Foundation

protocol LocationService {
    func loadLocations() async throws -> [LocationData]
}

class LocationServiceImplementation: LocationService {
    
    static let DEFAULT_URL: URL = URL(string: "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json")!
    private let httpClient: HTTPClient
    private let requestURL: URL
    
    
    init(httpClient: HTTPClient, requestURL: URL = DEFAULT_URL) {
        self.httpClient = httpClient
        self.requestURL = requestURL
    }
    
    func loadLocations() async throws -> [LocationData] {
        let response = await httpClient.get(from: requestURL)
        switch(response) {
        case .success((let data, _)):
            let decoder = JSONDecoder()
            return try decoder.decode([LocationData].self, from: data)
        case .failure(let error):
            throw error
        }
    }
}
