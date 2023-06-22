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
    func loadContent() async
}


class LocationsListViewModelImplementation: LocationsListViewModel {
    
    private let locationsRepository: LocationsRepository
        
    init(locationsRepository: LocationsRepository){
        self.locationsRepository = locationsRepository
    }
        
    func loadContent() async {
        _ = try? await self.locationsRepository.retrieveLocations()
    }

}


final class LocationsListViewModelTests: XCTestCase {
    
    private func createSUT() -> (LocationsListViewModel, LocationsRepositorySpy) {
        let repository = LocationsRepositorySpy()
        let viewModel = LocationsListViewModelImplementation(locationsRepository: repository)
        return(viewModel, repository)
    }
    
    func test_init_doesNotRetrieveLocations() {
        let (_, repository) = createSUT()
        XCTAssertEqual(repository.receivedMessage, [])
    }
    
    
    func test_loadContent_executeRetrieveCallOnRepository() async {
        let (sut, repository) = createSUT()
        
        await sut.loadContent()
        
        XCTAssertEqual(repository.receivedMessage, [.retrieve])
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
