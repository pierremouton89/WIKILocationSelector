//
//  LocationListViewModelLocationCaptureTests.swift
//  WIKILocationSelectorTests
//
//  Created by Pierre Mouton on 26/06/2023.
//

import XCTest

@testable import WIKILocationSelector

final class LocationListViewModelLocationCaptureTests: XCTestCase {

    private func anyDecimalString() -> String {
        return "123\(String.decimalSeparator)123"
    }
    
    private func createSUT() -> (LocationsListViewModel, DecimalInputStringFormatterSpy) {
        let decimalInputSpy = DecimalInputStringFormatterSpy()
        let viewModel =  LocationsListViewModelImplementation(locationsRepository: LocationsRepositorySpy(), router: AppRouterSpy(), decimalInputFormatter: decimalInputSpy)
        trackForMemoryLeaks(viewModel)
        return(viewModel, decimalInputSpy)
    }
    
    private var decimalSeparator: String = ""
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        decimalSeparator = try XCTUnwrap(String.decimalSeparator)
    }
    
    // MARK: - Latitude Input
    
    func test_bindingToLatitudeInput_nothingSet_EmptyStringIsPublished() async {
        let (sut, _) = createSUT()
        let expected = ""
        
        let expectation = XCTestExpectation(description: "Expected Value to be published")
        sut.latitudeInput.bind { result in
            XCTAssertEqual(expected, result)
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1)
    }
    
    func test_bindingToLatitudeInput_whenValueSetValidDecimalSet_decimalStringIsPublished() async {
        let (sut, _) = createSUT()
        let expected = "32\(decimalSeparator)32"
        
        let expectation = XCTestExpectation(description: "Expected Value to be published")
        sut.latitudeInput.value = expected
        sut.latitudeInput.bind { result in
            XCTAssertEqual(expected, result)
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1)
    }
    
    func test_updateLatitude_whenChangedCalled_shouldPassDataToDecimalInputStringFormatter() {
        let expectedInsert = "Insert"
        let (sut, formatterSpy) = createSUT()
        
        formatterSpy.complete(with: anyDecimalString())
        sut.updateLatitude(with: .changed(expectedInsert))
        
        XCTAssertEqual(formatterSpy.receivedMessage, [.whileEditing(expectedInsert)])
    }
    
    func test_updateLatitude_whenChangedCalled_shouldOutputResultFromDecimalInputStringFormatter() async {
        let expected = "Output"
        let (sut, formatterSpy) = createSUT()
        
        formatterSpy.complete(with: expected)
        
        let expectation = XCTestExpectation(description: "Expected Value to be published")
        sut.updateLatitude(with: .changed(anyDecimalString()))
        sut.latitudeInput.bind { result in
            XCTAssertEqual(expected, result)
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1)
    }
    
    func test_updateLatitude_whenEndEditing_shouldPassCurrentValueOfInputToDecimalInputStringFormatter() {
        let expectedInsert = "Insert"
        let (sut, formatterSpy) = createSUT()
        
        formatterSpy.complete(with: anyDecimalString())
        
        sut.latitudeInput.value = expectedInsert
        sut.updateLatitude(with: .endEditing)
        
        XCTAssertEqual(formatterSpy.receivedMessage, [.whenDoneEditing(expectedInsert)])
    }
    
    func test_updateLatitude_whenEndEditing_shouldOutputResultFromDecimalInputStringFormatter() async {
        let expected = "Output"
        let (sut, formatterSpy) = createSUT()

        formatterSpy.complete(with: expected)

        let expectation = XCTestExpectation(description: "Expected Value to be published")
        sut.latitudeInput.value = anyDecimalString()
        sut.updateLatitude(with: .endEditing)
        
        sut.latitudeInput.bind { result in
            XCTAssertEqual(expected, result)
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1)
    }
    
    
    
    // MARK: - Longitude Input
    
    func test_bindingToLongitudeInput_nothingSet_EmptyStringIsPublished() async {
        let (sut, _) = createSUT()
        let expected = ""
        
        let expectation = XCTestExpectation(description: "Expected Value to be published")
        sut.longitudeInput.bind { result in
            XCTAssertEqual(expected, result)
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1)
    }
    
    func test_bindingToLongitudeInput_decimalStringIsPublished() async {
        let (sut, _) = createSUT()
        let expected = "32\(decimalSeparator)32"
        
        let expectation = XCTestExpectation(description: "Expected Value to be published")
        sut.longitudeInput.value = expected
        sut.longitudeInput.bind { result in
            XCTAssertEqual(expected, result)
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1)
    }
    
    func test_updateLongitude_whenChangedCalled_shouldPassDataToDecimalInputStringFormatter() {
        let expectedInsert = "Insert"
        let (sut, formatterSpy) = createSUT()
        
        formatterSpy.complete(with: anyDecimalString())
        sut.updateLongitude(with: .changed(expectedInsert))
        
        XCTAssertEqual(formatterSpy.receivedMessage, [.whileEditing(expectedInsert)])
    }
    
    func test_updateLongitude_whenChangedCalled_shouldOutputResultFromDecimalInputStringFormatter() async {
        let expected = "Output"
        let (sut, formatterSpy) = createSUT()
        
        formatterSpy.complete(with: expected)
        
        let expectation = XCTestExpectation(description: "Expected Value to be published")
        sut.updateLongitude(with: .changed(anyDecimalString()))
        sut.longitudeInput.bind { result in
            XCTAssertEqual(expected, result)
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1)
    }
    
    func test_updateLongitude_whenEndEditing_shouldPassCurrentValueOfInputToDecimalInputStringFormatter() {
        let expectedInsert = "Insert"
        let (sut, formatterSpy) = createSUT()
        
        formatterSpy.complete(with: anyDecimalString())
        
        sut.longitudeInput.value = expectedInsert
        sut.updateLongitude(with: .endEditing)
        
        XCTAssertEqual(formatterSpy.receivedMessage, [.whenDoneEditing(expectedInsert)])
    }
    
    func test_updateLongitude_whenEndEditing_shouldOutputResultFromDecimalInputStringFormatter() async {
        let expected = "Output"
        let (sut, formatterSpy) = createSUT()

        formatterSpy.complete(with: expected)

        let expectation = XCTestExpectation(description: "Expected Value to be published")
        sut.longitudeInput.value = anyDecimalString()
        sut.updateLongitude(with: .endEditing)
        
        sut.longitudeInput.bind { result in
            XCTAssertEqual(expected, result)
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1)
    }
    
    
    // MARK: - Name Input
    
    func test_bindingToNameInput_nothingChanged_publishEmptyString() async {
        let (sut, _) = createSUT()
        let expected = ""
        
        let expectation = XCTestExpectation(description: "Expected Value to be published")
        sut.nameInput.bind { result in
            XCTAssertEqual(expected, result)
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1)
    }
    
    func test_bindingToNameInput_whenNonEmptyStringIsInitialValue_nonEmptyStringIsPublished() async {
        let (sut, _) = createSUT()
        let expected = "SomeValue"
        let expectation = XCTestExpectation(description: "Expected Value to be published")
        sut.nameInput.value = expected
        sut.nameInput.bind { result in
            XCTAssertEqual(expected, result)
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1)
    }
    
    func test_bindingToNameInput_whenEmptyStringIsInitialValue_anEmptyStringIsPublished() async {
        let (sut, _) = createSUT()
        let expected = ""
        let expectation = XCTestExpectation(description: "Expected Value to be published")
        sut.nameInput.value = expected
        sut.nameInput.bind { result in
            XCTAssertEqual(expected, result)
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1)
    }
}

class DecimalInputStringFormatterSpy: DecimalInputStringFormatter {
    enum ReceivedMessage: Equatable {
        case whileEditing(String)
        case whenDoneEditing(String)
    }
    private(set) var receivedMessage = [ReceivedMessage]()
    private var expectedResults = [String]()
    private var count = 0
    
    override func whileEditing(format decimalValue: String, decimalSeparator: String = String.decimalSeparator) -> String {
        receivedMessage.append(.whileEditing(decimalValue))
        let result = expectedResults[count]
        count += 1
        return result
    }
    
    override func whenDoneEditing(format decimalValue: String, decimalSeparator: String = String.decimalSeparator) -> String {
        receivedMessage.append(.whenDoneEditing(decimalValue))
        let result = expectedResults[count]
        count += 1
        return result
    }
    
    func complete(with value: String, at index: Int = 0){
        expectedResults.insert(value, at: index)
    }
    
}
