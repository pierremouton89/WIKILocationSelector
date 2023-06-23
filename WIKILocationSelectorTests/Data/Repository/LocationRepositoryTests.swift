//
//  LocationRepositoryTests.swift
//  WIKILocationSelectorTests
//
//  Created by Pierre Mouton on 23/06/2023.
//

import XCTest

extension LocationData {
    var location: Location {
        return .init(
            name: self.name,
            latitude: self.latitude,
            longitude: self.longitude
        )
    }
}

protocol LocationsRepository {
    func retrieveLocations() async throws -> [Location]
}

class LocationsRepositoryImplementation: LocationsRepository {
    private let locationService: LocationService
    
    init(locationService: LocationService){
        self.locationService = locationService
    }
    
    func retrieveLocations() async throws -> [Location] {
        let result = await self.locationService.loadLocations()
        switch(result) {
        case .success(let locations):
            return locations.map { $0.location }
        case .failure(let error):
            throw error
        }
    }
}

final class LocationsRepositoryTests: XCTestCase {
    
    
    func test_init_doesNotInvokeAnyMessageOnCreation() {
        let (_, service) = createSUT()
        
        XCTAssertEqual(service.receivedMessage, [])
    }
    
    func test_retrieveLoactions_serviceCalledToRetrieveLocations() async {
        let (sut, service) = createSUT()
        
        service.complete(with: [])
        _ = try? await sut.retrieveLocations()
        
        XCTAssertEqual(service.receivedMessage, [.retrieve])
    }
    
    func test_retrieveLocations_onSuccessReturnsLocations() async {
        let (sut, service) = createSUT()
        let item1 = LocationData(
            name: "Location1",
            latitude: 52.3547498,
            longitude: 4.8339215
        )
        let item2 = LocationData(
            name: "Copenhagen",
            latitude: 55.6713442,
            longitude: 12.523785
        )
        let item3 = LocationData(
            name: "Location3",
            latitude: 40.4380638,
            longitude: 3.7495758
        )
        
        let expectedItems = [item1, item2,item3]
        service.complete(with: expectedItems)
        
        do {
            let expectedResult = try await sut.retrieveLocations()
            XCTAssertEqual(expectedItems.map{ $0.location }, expectedResult)
        } catch {
            XCTFail("Expected an error to be thrown")
        }
        
    }
    
    func test_retrieveLocations_onFailureReturnsCorrectError() async {
        let (sut, service) = createSUT()
        let expectedError = anyNSError()
        
        service.complete(with: expectedError)
        
        do {
            _ = try await sut.retrieveLocations()
            XCTFail("Expected an error to be thrown")
        } catch {
            XCTAssertEqual(expectedError, error as NSError)
        }
        
    }
    
    
    private func createSUT() -> (LocationsRepository, LocationServiceSpy) {
        let service = LocationServiceSpy()
        let repository = LocationsRepositoryImplementation(locationService: service)
        return(repository, service)
    }
    
}

class LocationServiceSpy: LocationService {
    
    enum ReceivedMessage: Equatable {
        case retrieve
    }
    private(set) var receivedMessage = [ReceivedMessage]()
    private var results = [LocationResult]()
    private var count = 0
    
    func loadLocations() async -> LocationResult {
        receivedMessage.append(.retrieve)
        let result = results[count]
        self.count += 1
        return result
    }
    
    func complete(with locations: [LocationData],  at index: Int = 0) {
        self.results.insert(.success(locations), at: index)
    }
    
    func complete(with error: Error,  at index: Int = 0) {
        self.results.insert(.failure(error), at: index)
    }
    
}