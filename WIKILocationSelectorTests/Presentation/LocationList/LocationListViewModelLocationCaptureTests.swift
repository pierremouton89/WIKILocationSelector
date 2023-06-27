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
    
    private func anyValidDecimalString() -> String {
        return "123\(String.decimalSeparator)123"
    }
    
    private func createSUT() -> (LocationsListViewModel, DecimalInputStringFormatterSpy, AppRouterSpy) {
        let decimalInputSpy = DecimalInputStringFormatterSpy()
        let routerSpy = AppRouterSpy()
        let viewModel =  LocationsListViewModelImplementation(locationsRepository: LocationsRepositorySpy(), router: routerSpy, degreeInputFormatter: decimalInputSpy)
        trackForMemoryLeaks(viewModel)
        return(viewModel, decimalInputSpy, routerSpy)
    }
    
    
    private var decimalSeparator: String = ""
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        decimalSeparator = try XCTUnwrap(String.decimalSeparator)
    }
    
    // MARK: - Latitude Input
    
    func test_bindingToLatitudeInput_nothingSet_EmptyStringIsPublished() async {
        let (sut, _, _) = createSUT()
        let expected = ""
        
        let expectation = XCTestExpectation(description: "Expected Value to be published")
        sut.latitudeInput.bind { result in
            XCTAssertEqual(expected, result)
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1)
    }
    
    func test_bindingToLatitudeInput_whenValueSetValidDecimalSet_decimalStringIsPublished() async {
        let (sut, _, _) = createSUT()
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
        let (sut, formatterSpy, _) = createSUT()
        
        formatterSpy.complete(with: anyDecimalString())
        sut.updateLatitude(with: .changed(expectedInsert))
        
        XCTAssertEqual(formatterSpy.receivedMessage, [.whileEditing(expectedInsert)])
    }
    
    func test_updateLatitude_whenChangedCalled_shouldOutputResultFromDecimalInputStringFormatter() async {
        let expected = "Output"
        let (sut, formatterSpy, _) = createSUT()
        
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
        let (sut, formatterSpy, _) = createSUT()
        
        formatterSpy.complete(with: anyDecimalString())
        
        sut.latitudeInput.value = expectedInsert
        sut.updateLatitude(with: .endEditing)
        
        XCTAssertEqual(formatterSpy.receivedMessage, [.whenDoneEditing(expectedInsert)])
    }
    
    func test_updateLatitude_whenEndEditing_shouldOutputResultFromDecimalInputStringFormatter() async {
        let expected = "Output"
        let (sut, formatterSpy, _) = createSUT()

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
        let (sut, _, _) = createSUT()
        let expected = ""
        
        let expectation = XCTestExpectation(description: "Expected Value to be published")
        sut.longitudeInput.bind { result in
            XCTAssertEqual(expected, result)
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1)
    }
    
    func test_bindingToLongitudeInput_decimalStringIsPublished() async {
        let (sut, _, _) = createSUT()
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
        let (sut, formatterSpy, _) = createSUT()
        
        formatterSpy.complete(with: anyDecimalString())
        sut.updateLongitude(with: .changed(expectedInsert))
        
        XCTAssertEqual(formatterSpy.receivedMessage, [.whileEditing(expectedInsert)])
    }
    
    func test_updateLongitude_whenChangedCalled_shouldOutputResultFromDecimalInputStringFormatter() async {
        let expected = "Output"
        let (sut, formatterSpy, _) = createSUT()
        
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
        let (sut, formatterSpy, _) = createSUT()
        
        formatterSpy.complete(with: anyDecimalString())
        
        sut.longitudeInput.value = expectedInsert
        sut.updateLongitude(with: .endEditing)
        
        XCTAssertEqual(formatterSpy.receivedMessage, [.whenDoneEditing(expectedInsert)])
    }
    
    func test_updateLongitude_whenEndEditing_shouldOutputResultFromDecimalInputStringFormatter() async {
        let expected = "Output"
        let (sut, formatterSpy, _) = createSUT()

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
        let (sut, _, _) = createSUT()
        let expected = ""
        
        let expectation = XCTestExpectation(description: "Expected Value to be published")
        sut.nameInput.bind { result in
            XCTAssertEqual(expected, result)
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1)
    }
    
    func test_bindingToNameInput_whenNonEmptyStringIsInitialValue_nonEmptyStringIsPublished() async {
        let (sut, _, _) = createSUT()
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
        let (sut, _, _) = createSUT()
        let expected = ""
        let expectation = XCTestExpectation(description: "Expected Value to be published")
        sut.nameInput.value = expected
        sut.nameInput.bind { result in
            XCTAssertEqual(expected, result)
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1)
    }
    
    func test_updateNameWith_endEditingPassed_valueShouldNotChange() async {
        let (sut, _, _) = createSUT()
        let expected = "Test that this does not changed"
        
        
        sut.nameInput.value = expected
    
        sut.updateName(with: .endEditing)
        
        XCTAssertEqual(expected, sut.nameInput.value)
    }
    
    func test_updateNameWith_changedWithNewValuePassed_nameInputPublishesValue() async {
        let (sut, _, _) = createSUT()
        let expected = "Update to be applied"
        
        let expectation = XCTestExpectation(description: "Expected Value to be published")
    
        sut.updateName(with: .changed(expected))
        
        sut.nameInput.bind { result in
            XCTAssertEqual(expected, result)
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1)
    }
    
    // MARK: - Name Description
    
    func test_bindingToNameDescription_publishesDefaultNameDescription() async {
        let (sut, _, _) = createSUT()
        let expected = LocationsListViewModelImplementation.NAME_DESCRIPTION
        
        let expectation = XCTestExpectation(description: "Expected Value to be published")
        sut.nameDescription.bind { result in
            XCTAssertEqual(expected, result)
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1)
    }
    
    // MARK: - Latitude Description
    
    func test_bindingToLatitudeDescription_publishesDefaultLatitudeDescription() async {
        let (sut, _, _) = createSUT()
        let expected = LocationsListViewModelImplementation.LATITUDE_DESCRIPTION
        
        let expectation = XCTestExpectation(description: "Expected Value to be published")
        sut.latitudeDescription.bind { result in
            XCTAssertEqual(expected, result)
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1)
    }
    
    
    // MARK: - Longitude Description
    
    func test_bindingToLongitudeDescription_publishesDefaultLatitudeDescription() async {
        let (sut, _, _) = createSUT()
        let expected = LocationsListViewModelImplementation.LONGITUDE_DESCRIPTION
        
        let expectation = XCTestExpectation(description: "Expected Value to be published")
        sut.longitudeDescription.bind { result in
            XCTAssertEqual(expected, result)
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1)
    }
    
    
    // MARK: - Name Placeholder
    
    func test_bindingToNamePlaceHolder_publishesDefaultNamePlaceHolder() async {
        let (sut, _, _) = createSUT()
        let expected = LocationsListViewModelImplementation.NAME_PLACEHOLDER
        
        let expectation = XCTestExpectation(description: "Expected Value to be published")
        sut.namePlaceHolder.bind { result in
            XCTAssertEqual(expected, result)
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1)
    }
    
    // MARK: - Latitude PlaceHolder
    
    func test_bindingToLatitudePlaceHolder_publishesDefaultLatitudePlaceHolder() async {
        let (sut, _ ,_) = createSUT()
        let expected = LocationsListViewModelImplementation.LATITUDE_PLACEHOLDER
        
        let expectation = XCTestExpectation(description: "Expected Value to be published")
        sut.latitudePlaceHolder.bind { result in
            XCTAssertEqual(expected, result)
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1)
    }
    
    
    // MARK: - Longitude PlaceHolder
    
    func test_bindingToLongitudePlaceHolder_publishesDefaultLatitudePlaceHolder() async {
        let (sut, _, _) = createSUT()
        let expected = LocationsListViewModelImplementation.LONGITUDE_PLACEHOLDER
        
        let expectation = XCTestExpectation(description: "Expected Value to be published")
        sut.longitudePlaceHolder.bind { result in
            XCTAssertEqual(expected, result)
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1)
    }
    
    
    // MARK: - Open location
    
    func test_bindingToOpenLocationEnabled_noUpdates_returnsFalse() async {
        let (sut, _, _) = createSUT()
        
        let expectation = XCTestExpectation(description: "Expected Value to be published")
        
        sut.openLocationEnabled.bind { result in
            XCTAssertFalse(result)
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1)
    }
    
    func test_bindingToOpenLocationEnabled_updateOnlyAValidLatitiude_returnsFalse() async {
        let (sut, formatterSpy, _) = createSUT()
        
        let expectation = XCTestExpectation(description: "Expected Value to be published")
        formatterSpy.complete(with: anyValidDecimalString())
        sut.updateLatitude(with: .changed(anyDecimalString()))
        
        sut.openLocationEnabled.bind { result in
            XCTAssertFalse(result)
            expectation.fulfill()
        }
        
        
        await fulfillment(of: [expectation], timeout: 1)
        
    }
    
    func test_bindingToOpenLocationEnabled_updateOnlyAValidLongitude_returnsFalse() async {
        let (sut, formatterSpy, _) = createSUT()
        
        let expectation = XCTestExpectation(description: "Expected Value to be published")
        formatterSpy.complete(with: anyValidDecimalString())
        sut.updateLongitude(with: .changed(anyDecimalString()))
        
        sut.openLocationEnabled.bind { result in
            XCTAssertFalse(result)
            expectation.fulfill()
        }
        
        
        await fulfillment(of: [expectation], timeout: 1)
        
    }
    
    func test_bindingToOpenLocationEnabled_updateBothLongitudeAndLongitudeToValidValues_returnsTrue() async {
        let (sut, formatterSpy, _) = createSUT()
        
        formatterSpy.complete(with: anyValidDecimalString())
        formatterSpy.complete(with: anyValidDecimalString())
        
        sut.updateLongitude(with: .changed(anyDecimalString()))
        let expectation1 = XCTestExpectation(description: "Expected Value to be published")
        sut.openLocationEnabled.bind { result in
            expectation1.fulfill()
        }
        
        let expectation2 = XCTestExpectation(description: "Expected Value to be published")
        sut.updateLatitude(with: .changed(anyDecimalString()))
        
        sut.openLocationEnabled.bind { result in
            XCTAssertTrue(result)
            expectation2.fulfill()
        }
        
        
        await fulfillment(of: [expectation1, expectation2], timeout: 1)
        
    }
    

    func test_bindingToOpenLocationEnabled_updateLongitudeInvalidAndLongitudeToValid_returnsFalse() async {
        let (sut, formatterSpy, _) = createSUT()

        let expectation1 = XCTestExpectation(description: "Expected Value to be published")
        formatterSpy.completeWithInvalidValue()
        formatterSpy.complete(with: anyValidDecimalString())
        
        sut.updateLongitude(with: .changed(anyDecimalString()))

        sut.openLocationEnabled.bind { result in
            expectation1.fulfill()
        }

        let expectation2 = XCTestExpectation(description: "Expected Value to be published")
        sut.updateLatitude(with: .changed(anyDecimalString()))

        sut.openLocationEnabled.bind { result in
            XCTAssertFalse(result)
            expectation2.fulfill()
        }


        await fulfillment(of: [expectation1, expectation2], timeout: 1)

    }
    
    func test_bindingToOpenLocationEnabled_updateLongitudeValidAndInvalidLongitude_returnsFalse() async {
        let (sut, formatterSpy, _) = createSUT()

        let expectation1 = XCTestExpectation(description: "Expected Value to be published")
        formatterSpy.complete(with: anyValidDecimalString())
        formatterSpy.completeWithInvalidValue()
        
        sut.updateLongitude(with: .changed(anyDecimalString()))

        sut.openLocationEnabled.bind { result in
            XCTAssertFalse(result)
            expectation1.fulfill()
        }

        let expectation2 = XCTestExpectation(description: "Expected Value to be published")
        sut.updateLatitude(with: .changed(anyDecimalString()))

        sut.openLocationEnabled.bind { result in
            XCTAssertFalse(result)
            expectation2.fulfill()
        }


        await fulfillment(of: [expectation1, expectation2], timeout: 1)
    }

    
    func test_openLocation_passesLocation_toPresentSelectedLocationOnRouter() async {
        let (sut, _, router) = createSUT()
    
        let location = Location(
            latitude: 52.3547498,
            longitude: 4.8339215
        )
        sut.longitudeInput.value = location.longitude.description
        sut.latitudeInput.value = location.latitude.description
        
        sut.openLocation()
        
        XCTAssertEqual([.selectedLocation(location)], router.receivedMessage)
        
    }
    
    // MARK: - Add location
    
    func test_bindingToAddLocationEnabled_noUpdates_returnsFalse() async {
        let (sut, _, _) = createSUT()
        
        let expectation = XCTestExpectation(description: "Expected Value to be published")
        
        sut.addLocationEnabled.bind { result in
            XCTAssertFalse(result)
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1)
    }
    
    func test_bindingToAddLocationEnabled_updateOnlyAValidLatitiude_returnsFalse() async {
        let (sut, formatterSpy, _) = createSUT()
        
        let expectation = XCTestExpectation(description: "Expected Value to be published")
        formatterSpy.complete(with: anyValidDecimalString())
        sut.updateLatitude(with: .changed(anyDecimalString()))
        
        sut.addLocationEnabled.bind { result in
            XCTAssertFalse(result)
            expectation.fulfill()
        }
        
        
        await fulfillment(of: [expectation], timeout: 1)
        
    }
    
    func test_bindingToAddLocationEnabled_updateOnlyAValidLongitude_returnsFalse() async {
        let (sut, formatterSpy, _) = createSUT()
        
        let expectation = XCTestExpectation(description: "Expected Value to be published")
        formatterSpy.complete(with: anyValidDecimalString())
        sut.updateLongitude(with: .changed(anyDecimalString()))
        
        sut.addLocationEnabled.bind { result in
            XCTAssertFalse(result)
            expectation.fulfill()
        }
        
        
        await fulfillment(of: [expectation], timeout: 1)
        
    }
    
    func test_bindingToAddLocationEnabled_updateBothLongitudeAndLongitudeToValidValues_returnsTrue() async {
        let (sut, formatterSpy, _) = createSUT()
        
        let expectation1 = XCTestExpectation(description: "Expected Value to be published")
        formatterSpy.complete(with: anyValidDecimalString())
        formatterSpy.complete(with: anyValidDecimalString())
        
        sut.updateLongitude(with: .changed(anyDecimalString()))
        sut.addLocationEnabled.bind { result in
            XCTAssertFalse(result)
            expectation1.fulfill()
        }
        
        let expectation2 = XCTestExpectation(description: "Expected Value to be published")
        sut.updateLatitude(with: .changed(anyDecimalString()))
        
        sut.addLocationEnabled.bind { result in
            XCTAssertTrue(result)
            expectation2.fulfill()
        }
        
        
        await fulfillment(of: [expectation1, expectation2], timeout: 1)
        
    }
    

    func test_bindingToAddLocationEnabled_updateLongitudeInvalidAndLongitudeToValid_returnsFalse() async {
        let (sut, formatterSpy, _) = createSUT()

        let expectation1 = XCTestExpectation(description: "Expected Value to be published")
        formatterSpy.completeWithInvalidValue()
        formatterSpy.complete(with: anyValidDecimalString())
        
        sut.updateLongitude(with: .changed(anyDecimalString()))

        sut.addLocationEnabled.bind { result in
            XCTAssertFalse(result)
            expectation1.fulfill()
        }

        let expectation2 = XCTestExpectation(description: "Expected Value to be published")
        sut.updateLatitude(with: .changed(anyDecimalString()))

        sut.addLocationEnabled.bind { result in
            XCTAssertFalse(result)
            expectation2.fulfill()
        }


        await fulfillment(of: [expectation1, expectation2], timeout: 1)

    }
    
    func test_bindingToAddLocationEnabled_updateLongitudeValidAndInvalidLongitude_returnsFalse() async {
        let (sut, formatterSpy, _) = createSUT()

        let expectation1 = XCTestExpectation(description: "Expected Value to be published")
        formatterSpy.complete(with: anyValidDecimalString())
        formatterSpy.completeWithInvalidValue()
        
        sut.updateLongitude(with: .changed(anyDecimalString()))

        sut.addLocationEnabled.bind { result in
            XCTAssertFalse(result)
            expectation1.fulfill()
        }

        let expectation2 = XCTestExpectation(description: "Expected Value to be published")
        sut.updateLatitude(with: .changed(anyDecimalString()))

        sut.addLocationEnabled.bind { result in
            XCTAssertFalse(result)
            expectation2.fulfill()
        }


        await fulfillment(of: [expectation1, expectation2], timeout: 1)
    }
    
    func test_addLocation_appendLocation_toDisplayModels() async {
        let (sut, _, _) = createSUT()
    
        let location = Location(
            latitude: 52.3547498,
            longitude: 4.8339215
        )
        sut.longitudeInput.value = location.longitude.description
        sut.latitudeInput.value = location.latitude.description
        
        sut.addLocation()
        
        XCTAssertEqual([location].map{LocationDisplayModel(location: $0)}, sut.displayModels.value)
        
    }
    
    func test_addLocation_passesLocation_toAppendLocationToLocationsList() async {
        let (sut, _, _) = createSUT()
    
        let location = Location(
            latitude: 52.3547498,
            longitude: 4.8339215
        )
        sut.longitudeInput.value = location.longitude.description
        sut.latitudeInput.value = location.latitude.description
        
        sut.addLocation()
        
        let expectation = XCTestExpectation(description: "Expected Value to be published")
        sut.displayModels.bind { result in
            XCTAssertEqual([location].map{LocationDisplayModel(location: $0)}, result)
            expectation.fulfill()
        }

        await fulfillment(of: [expectation], timeout: 1)
    }
    
    
}

class DecimalInputStringFormatterSpy: LocationDegreeInputFormatter {
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
    
    func completeWithInvalidValue( at index: Int = 0){
        expectedResults.insert("", at: index)
    }
    
}
