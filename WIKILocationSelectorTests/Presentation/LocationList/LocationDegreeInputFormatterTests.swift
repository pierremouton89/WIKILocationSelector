//
//  LocationDegreeInputFormatterTests.swift
//  WIKILocationSelectorTests
//
//  Created by Pierre Mouton on 26/06/2023.
//

import XCTest
@testable import WIKILocationSelector

final class LocationDegreeInputFormatterTests: XCTestCase {
    
    private func createSUT() -> LocationDegreeInputFormatter {
        return .init()
    }
    
    private var decimalSeparator: String = ""
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        decimalSeparator = try XCTUnwrap(Locale.autoupdatingCurrent.decimalSeparator)
    }

    // MARK: - whileEditingFormatDecimal
    func test_whileEditingFormatDecimal_whenCalledWithDoubleDecimalSeparatorString_returnCorrectValue()  {
        let entered = "32\(decimalSeparator)32\(decimalSeparator)00"
        let expected = "32\(decimalSeparator)3200"
        let sut = createSUT()
        
        let result = sut.whileEditing(format: entered)
        
        XCTAssertEqual(expected, result)
    }
    
    
    func test_whileEditingFormatDecimal_whenCalledWithDoubleDecimalSeparatorAndTextString_retunsValidDecimal() {
        let entered = "A32\(decimalSeparator)32A\(decimalSeparator)00"
        let expected = "32\(decimalSeparator)3200"
        let sut = createSUT()
        
        let result = sut.whileEditing(format: entered)
        
        XCTAssertEqual(expected, result)
    }

    func test_whileEditingFormatDecimal_whenCalledWithWithNoValueBeforeDecimalSeparatorAndDoubleDecimalSeparator_returnsCorrectValue()  {
        let entered = "\(decimalSeparator)32A\(decimalSeparator)00"
        let expected = "\(decimalSeparator)3200"
        let sut = createSUT()
        
        let result = sut.whileEditing(format: entered)
        
        XCTAssertEqual(expected, result)
    }

    func test_whileEditingFormatDecimal_whenCalledWithOnlyDecimapSeparator_returnsZeroAndDecimalSepartor()  {
        let entered = "\(decimalSeparator)"
        let expected = "\(decimalSeparator)"
        let sut = createSUT()
        
        let result = sut.whileEditing(format: entered)
        
        XCTAssertEqual(expected, result)
    }

    func test_whileEditingFormatDecimal_whenCalledDashWithOnlyCharactersAndDecimalSepartor_returnsDashAndDecimalSepartor() {
        let entered = "-AAA\(decimalSeparator)"
        let expected = "-\(decimalSeparator)"
        let sut = createSUT()
        
        let result = sut.whileEditing(format: entered)
        
        XCTAssertEqual(expected, result)
    }
    
    func test_whileEditingFormatDecimal_whenCalledDashAndDecimalSepartor_returnsDashAndDecimalSepartor() {
        let entered = "-\(decimalSeparator)"
        let expected = "-\(decimalSeparator)"
        let sut = createSUT()
        
        let result = sut.whileEditing(format: entered)
        
        XCTAssertEqual(expected, result)
    }

    func test_whileEditingFormatDecimal_whennCalledNumberWithDashInMiddleAndCharacters_returnsCorrectDecimalString() {
        let entered = "123-A\(decimalSeparator)a-321"
        let expected = "123\(decimalSeparator)321"
        let sut = createSUT()
        
        let result = sut.whileEditing(format: entered)
        
        XCTAssertEqual(expected, result)
    }

    func test_whileEditingFormatDecimal_whenCalledWithEmptyString_returnsEmptyString()  {
        let entered = ""
        let expected = ""
        let sut = createSUT()
        
        let result = sut.whileEditing(format: entered)
        
        XCTAssertEqual(expected, result)
    }

    func test_whileEditingFormatDecimal_whenCalledWithDoubleDashInMiddleAndCharacters_returnsSingleDash() async {
        
        let entered = "--"
        let expected = "-"
        let sut = createSUT()
        
        let result = sut.whileEditing(format: entered)
        
        XCTAssertEqual(expected, result)
    }

    func test_whileEditingFormatDecimal_whenCalledWithDashZero_returnsDashZero() async {
        let entered = "-0"
        let expected =  "-0"
        let sut = createSUT()
        
        let result = sut.whileEditing(format: entered)
        
        XCTAssertEqual(expected, result)
    }

    func test_whileEditingFormatDecimal_whenCalledDashAndNoDecimalSeparator_returhsDashAndNoDecimalSeparator() async {
        let entered = "-1231"
        let expected =  "-1231"
        let sut = createSUT()
        
        let result = sut.whileEditing(format: entered)
        
        XCTAssertEqual(expected, result)
    }
    
    // MARK: - whenDoneEditing
    
    func test_whenDoneEditing_negativeWithTrailingDecimalSepartor_returnNegativeWithRemovedDecimalSeperator()  {
        let entered = "-1\(decimalSeparator)"
        let expected = "-1"
        let sut = createSUT()
        
        let result = sut.whenDoneEditing(format: entered, degreeBounds: .init(max: 90, min: -90))
        
        XCTAssertEqual(expected, result)
    }
    
    func test_whenDoneEditing_whenNegativeValueLargerThanSpecified_returnMinimumValue()  {
        let entered = "-10001"
        let expected = "-90"
        let sut = createSUT()
        
        let result = sut.whenDoneEditing(format: entered, degreeBounds: .init(max: 90, min: -90))
        
        XCTAssertEqual(expected, result)
    }
    
    
    func test_whenDoneEditing_negativeWithPrefixedZeroDecimalSepartor_returnNegativeWithRemovePrefixedZero() {
        let entered = "-0031"
        let expected = "-31"
        let sut = createSUT()
        
        let result = sut.whenDoneEditing(format: entered, degreeBounds: .init(max: 90, min: -90))
        
        XCTAssertEqual(expected, result)
    }
    
    func test_whenDoneEditing_negativeDecimalWithPrefixedZerosAndSuffixed_returnTrimZeros() {
        let entered = "-0012\(decimalSeparator)001313000"
        let expected = "-12\(decimalSeparator)001313"
        let sut = createSUT()
        
        let result = sut.whenDoneEditing(format: entered, degreeBounds: .init(max: 90, min: -90))
        
        XCTAssertEqual(expected, result)
    }
    
    func test_whenDoneEditing_postiveWithTrailingDecimalSepartor_returnsWithRemoveDecimalSeperator()  {
        let entered = "50\(decimalSeparator)"
        let expected = "50"
        let sut = createSUT()
        
        let result = sut.whenDoneEditing(format: entered, degreeBounds: .init(max: 90, min: -90))
        
        XCTAssertEqual(expected, result)
    }
    
    func test_whenDoneEditing_positiveWithPrefixedZeroDecimalSepartor_returnsWithRemovePrefixedZero() {
        let entered = "000013"
        let expected = "13"
        let sut = createSUT()
        
        let result = sut.whenDoneEditing(format: entered, degreeBounds: .init(max: 90, min: -90))
        
        XCTAssertEqual(expected, result)
    }
    
    func test_whenDoneEditing_positiveDecimalWithPrefixedZerosAndSuffixed_returnTrimZeros() {
        let entered = "00011\(decimalSeparator)00098000"
        let expected = "11\(decimalSeparator)00098"
        let sut = createSUT()
        
        let result = sut.whenDoneEditing(format: entered, degreeBounds: .init(max: 90, min: -90))
        
        XCTAssertEqual(expected, result)
    }
    
    func test_whenDoneEditing_whenNegativeValueLargerThanSpecified_returMaximumValue()  {
        let entered = "1000"
        let expected = "90"
        let sut = createSUT()
        
        let result = sut.whenDoneEditing(format: entered, degreeBounds: .init(max: 90, min: -90))
        
        XCTAssertEqual(expected, result)
    }
    
    func test_whenDoneEditing_emptyString_returnEmptyString() {
        let entered = ""
        let expected = ""
        let sut = createSUT()
        
        let result = sut.whenDoneEditing(format: entered, degreeBounds: .init(max: 90, min: -90))
        
        XCTAssertEqual(expected, result)
    }
    
    func test_whenDoneEditing_negativeZero_returnZero() {
        let entered = "-0"
        let expected = "0"
        let sut = createSUT()
        
        let result = sut.whenDoneEditing(format: entered, degreeBounds: .init(max: 90, min: -90))
        
        XCTAssertEqual(expected, result)
    }
    
    func test_whenDoneEditing_whenCalledWithOnlyDecimapSeparator_returnsZero()  {
        let entered = "\(decimalSeparator)"
        let expected = "0"
        let sut = createSUT()
        
        let result = sut.whenDoneEditing(format: entered, degreeBounds: .init(max: 90, min: -90))
        
        XCTAssertEqual(expected, result)
    }

    func test_whenDoneEditing_whenCalledWithDashStringAndDecimalSepartor_returnsZero() {
        let entered = "-AAA\(decimalSeparator)"
        let expected = "0"
        let sut = createSUT()
        
        let result = sut.whenDoneEditing(format: entered, degreeBounds: .init(max: 90, min: -90))
        
        XCTAssertEqual(expected, result)
    }
    
    func test_whenDoneEditing_whenCalledWithDashAndDecimalSepartor_returnsZero() {
        let entered = "-\(decimalSeparator)"
        let expected = "0"
        let sut = createSUT()
        
        let result = sut.whenDoneEditing(format: entered, degreeBounds: .init(max: 90, min: -90))
        
        XCTAssertEqual(expected, result)
    }
    
}
