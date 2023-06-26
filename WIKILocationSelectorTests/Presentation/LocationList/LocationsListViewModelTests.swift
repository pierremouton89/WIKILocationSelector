//
//  LocationsListViewModelTests.swift
//  WIKILocationSelectorTests
//
//  Created by Pierre Mouton on 22/06/2023.
//

import XCTest
@testable import WIKILocationSelector


final class LocationsListViewModelTests: XCTestCase {

    
    private func createSUT() -> (LocationsListViewModel, LocationsRepositorySpy, AppRouterSpy) {
        let repository = LocationsRepositorySpy()
        let appRouter = AppRouterSpy()
        let viewModel =  LocationsListViewModelImplementation(locationsRepository: repository, router: appRouter)
        trackForMemoryLeaks(viewModel)
        return(viewModel, repository, appRouter)
    }
    
    func test_init_doesNotRetrieveLocations() {
        let (_, repository, _) = createSUT()
        XCTAssertEqual(repository.receivedMessage, [])
    }
    
    
    func test_loadContent_executeRetrieveCallOnRepository() async {
        let (sut, repository, _) = createSUT()
        
        repository.complete(with: [])
        await sut.loadContent()
        
        XCTAssertEqual(repository.receivedMessage, [.retrieve])
    }
    
    func test_loadContent_emptyListRetrievedFromRepositoryThenListIsPublishedToLocations() async {
        let (sut, repository, _) = createSUT()
        let expectedResult = [Location]()
        repository.complete(with: expectedResult)
        
        await sut.loadContent()
        let expectation = XCTestExpectation(description: "Expected empty location list to return")
        
        sut.displayModels.bind { result in
            XCTAssertEqual(expectedResult, result.map{$0.location})
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation])
    }
    
    func test_loadContent_populatedListRetrievedFromRepositoryThenListIsPublishedToLocations() async {
        let (sut, repository, _) = createSUT()
        
        let item1 = Location(
            name: "Location1",
            latitude: 52.3547498,
            longitude: 4.8339215
        )
        let item2 = Location(
            name: "Copenhagen",
            latitude: 55.6713442,
            longitude: 12.523785
        )
        let item3 = Location(
            name: "Location3",
            latitude: 40.4380638,
            longitude: 3.7495758
        )
        
        let expectedResult = [item1, item3 ,item2]
        repository.complete(with: expectedResult)
        
        await sut.loadContent()
        let expectation = XCTestExpectation(description: "Expected location list to return")
        
        sut.displayModels.bind { result in
            XCTAssertEqual(expectedResult, result.map{$0.location})
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 1)
    }
    
    func test_loadContent_whenErrorIsRetrievedFromRepositoryEmptyListIsPublishedToLocations() async {
        let (sut, repository, _) = createSUT()
        
        repository.complete(with: anyNSError())
        
        await sut.loadContent()
        
        let expectation = XCTestExpectation(description: "Expected location list to return")
        sut.displayModels.bind { result in
            XCTAssertEqual([LocationDisplayModel](), result)
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1)
    }
    
    func test_loadContent_whenErrorIsRecievedFromRepositoryCallPresentMessageOnRouter() async {
        let (sut, repository, router) = createSUT()
        
        let error = anyNSError()
        repository.complete(with: error)
        
        await sut.loadContent()
        
        XCTAssertEqual([.error(error.localizedDescription)], router.receivedMessage)
    }
    
    func test_bindingToTitle_publishesTitle() async {
        let (sut, _, _) = createSUT()
        
        let expectation = XCTestExpectation(description: "Expected title to be published")
        sut.title.bind { title in
            XCTAssertEqual(LocationsListViewModelImplementation.TITLE, title)
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1)
    }
    
    func test_selectLocationAtIndex_aValidIndexSelectedThenPresentSelectedLocationOnRouter() async {
        let (sut, repository, router) = createSUT()

        let item1 = Location(
            name: "Location1",
            latitude: 52.3547498,
            longitude: 4.8339215
        )
        let item2 = Location(
            name: "",
            latitude: 55.6713442,
            longitude: 12.523785
        )
        let item3 = Location(
            name: "Location3",
            latitude: 40.4380638,
            longitude: 3.7495758
        )
        
        let expectedResult = [item1, item2 ,item3]
        repository.complete(with: expectedResult)
        
        await sut.loadContent()
        
        sut.selectLocation(at: 1)
        
        XCTAssertEqual([.selectedLocation(item2)], router.receivedMessage)
    }
    
    func test_selectLocationAtIndex_anInvalidIndexSelectedDoesNothing() async {
        let (sut, repository, router) = createSUT()

        let item1 = Location(
            name: "Location1",
            latitude: 52.3547498,
            longitude: 4.8339215
        )
        let item2 = Location(
            name: "Copenhagen",
            latitude: 55.6713442,
            longitude: 12.523785
        )
        let item3 = Location(
            latitude: 40.4380638,
            longitude: 3.7495758
        )
        
        let expectedResult = [item1, item2 ,item3]
        repository.complete(with: expectedResult)
        
        await sut.loadContent()
        
        sut.selectLocation(at: 40)
        
        XCTAssertEqual([], router.receivedMessage)
    }
    
    func test_selectLocationAtIndex_anNegativeIndexSelectedDoesNothing() async {
        let (sut, repository, router) = createSUT()

        let item1 = Location(
            latitude: 52.3547498,
            longitude: 4.8339215
        )
        let item2 = Location(
            name: "Copenhagen",
            latitude: 55.6713442,
            longitude: 12.523785
        )
        let item3 = Location(
            name: "Location3",
            latitude: 40.4380638,
            longitude: 3.7495758
        )
        
        let expectedResult = [item1, item2 ,item3]
        repository.complete(with: expectedResult)
        
        await sut.loadContent()
        
        sut.selectLocation(at: -2)
        
        XCTAssertEqual([], router.receivedMessage)
    }
    
    func test_bindingToDisplayModels_whenLoadContentNotCalled_anEmptyArrayIsPublished() async {
        let (sut, _, _) = createSUT()
        
        
        let expectation = XCTestExpectation(description: "Expected DisplayModels to be published")
        sut.displayModels.bind { result in
            XCTAssertEqual([LocationDisplayModel](), result)
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1)
    }
    
    func test_bindingToDisplayModels_whenLoadContentAndRepositoryContainsEmptyList_anEmptyArrayIsPublished() async {
        let (sut, repository, _) = createSUT()
        
        let expectedResult = [Location]()
        repository.complete(with: expectedResult)
        let expectation = XCTestExpectation(description: "Expected DisplayModels to be published")
        sut.displayModels.bind { result in
            XCTAssertEqual(expectedResult.map { .init(location: $0) }, result)
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1)
    }
    
    func test_bindingToDisplayModels_whenLoadContentAndRepositoryContainsLocations_locationDisplayArrayIsPublished() async {
        let (sut, repository, _) = createSUT()
        
        let item1 = Location(
            name: "Location3",
            latitude: 4.4,
            longitude: 4.8339215
        )
        let item2 = Location(
            name: "Copenhagen",
            latitude: 3.0,
            longitude: 1.0
        )
        let item3 = Location(
            name: "Location3",
            latitude: 8.9,
            longitude: 3.7495758
        )
        let expectedResult = [item1, item2 ,item3]
        repository.complete(with: expectedResult)
        
        await sut.loadContent()
        
        let expectation = XCTestExpectation(description: "Expected DisplayModels to be published")
        sut.displayModels.bind { result in
            XCTAssertEqual(expectedResult.map { .init(location:$0) }, result)
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1)
    }
    
    
    
}

class LocationsRepositorySpy: LocationsRepository {
    
    enum ReceivedMessage: Equatable {
        case retrieve
    }
    private(set) var receivedMessage = [ReceivedMessage]()
    private var results = [Result<[Location],Error>]()
    private var count = 0
    
    func retrieveLocations() async throws -> [Location] {
        receivedMessage.append(.retrieve)
        let result = results[count]
        self.count += 1
        switch(result) {
        case .success(let locations):
            return locations
        case .failure(let error):
            throw error
        }
    }
    
    func complete(with locations: [Location],  at index: Int = 0) {
        self.results.insert(.success(locations), at: index)
    }
    
    func complete(with error: Error,  at index: Int = 0) {
        self.results.insert(.failure(error), at: index)
    }
}

class AppRouterSpy: AppRouter {
    
    enum ReceivedMessage: Equatable {
        case error(String)
        case selectedLocation(Location)
    }
    
    private(set) var receivedMessage = [ReceivedMessage]()
    
    func presentListScreen() {
    }
    
    func presentAlert(with message: String) {
        self.receivedMessage.append(.error(message))
    }
    
    func presentSelected(location: Location) {
        self.receivedMessage.append(.selectedLocation(location))
    }
    
}
