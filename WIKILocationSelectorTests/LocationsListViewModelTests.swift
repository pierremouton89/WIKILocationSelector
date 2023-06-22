//
//  LocationsListViewModelTests.swift
//  WIKILocationSelectorTests
//
//  Created by Pierre Mouton on 22/06/2023.
//

import XCTest
@testable import WIKILocationSelector

struct Location {
    
}

protocol LocationsRepository {
    func retrieveLocations() async throws -> [Location]
}

protocol LocationsListViewModel {
}


class LocationsListViewModelImplementation: LocationsListViewModel {
    

}



final class LocationsListViewModelTests: XCTestCase {
    
    func test_init_doesNotRetrieveLocations() {
        let (_, repository) = createSUT()
        XCTAssertEqual(repository.receivedMessage, [])
    }
    
    func createSUT() -> (LocationsListViewModel, LocationsRepositorySpy) {
        let viewModel = LocationsListViewModelImplementation()
        return(viewModel, LocationsRepositorySpy())
    }
}


class LocationsRepositorySpy: LocationsRepository {
    
    
    enum ReceivedMessage: Equatable {
        case retrieve
    }
    private(set) var receivedMessage = [ReceivedMessage]()
    
    func retrieveLocations() async throws -> [Location] {
        receivedMessage.append(.retrieve)
        return []
    }
    
    
}
    

