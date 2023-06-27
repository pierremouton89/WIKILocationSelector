//
//  LocationDisplayModelTests.swift
//  WIKILocationSelectorTests
//
//  Created by Pierre Mouton on 26/06/2023.
//

import XCTest
@testable import WIKILocationSelector

final class LocationDisplayModelTests: XCTestCase {

    func test_name_whenSetToEmptyString_returnsUnknown()  {
        let location = Location(name:"", latitude: 20.0, longitude: 30.0)
        let sut = LocationDisplayModel(location: location)
        
        XCTAssertEqual("Unknown", sut.name)
    }
    
    func test_name_whenSetToNull_returnsUnknown()  {
        let location = Location(name: nil, latitude: 20.0, longitude: 30.0)
        let sut = LocationDisplayModel(location: location)
        
        XCTAssertEqual("Unknown", sut.name)
        
    }
    
    func test_name_whenSetToNonEmptyName_returnsName()  {
        let expectedValue = "Name"
        let location = Location(name: expectedValue, latitude: 20.0, longitude: 30.0)
        
        let sut = LocationDisplayModel(location: location)
        
        XCTAssertEqual(expectedValue, sut.name)
    }
    
    func test_latitudeDescription_whenSetToEmptyString_returnsEmptyString()  {
        let expectedValue = ""
        let location = anyLocation()
        
        let sut = LocationDisplayModel(latitudeDescription: expectedValue, location: location)
        
        XCTAssertEqual("", sut.latitudeDescription)
        
    }
    
    func test_latitudeDescription_whenSetToNonString_returnsEmptyString()  {
        let expectedValue = "Name"
        let location = anyLocation()
        
        let sut = LocationDisplayModel(latitudeDescription: expectedValue, location: location)
        
        XCTAssertEqual(expectedValue, sut.latitudeDescription)
        
    }
    
    func test_latitudeDescription_whenNotSpecified_returnsDefaultLabel()  {
        let expectedValue = "Latitude:"
        let location = anyLocation()
        
        let sut = LocationDisplayModel(location: location)
        
        XCTAssertEqual(expectedValue, sut.latitudeDescription)
        
    }
    
    func test_longitudeDescription_whenSetToEmptyString_returnsEmptyString()  {
        let expectedValue = ""
        let location = anyLocation()
        
        let sut = LocationDisplayModel(longitudeDescription: expectedValue, location: location)
        
        XCTAssertEqual("", sut.longitudeDescription)
    }
    
    func test_longitudeDescription_whenSetToNonString_returnsEmptyString()  {
        let expectedValue = "Name"
        let location = anyLocation()
        
        let sut = LocationDisplayModel(longitudeDescription: expectedValue, location: location)
        
        XCTAssertEqual(expectedValue, sut.longitudeDescription)
    }
    
    func test_longitudeDescription_whenNotSpecified_returnsDefaultLabel()  {
        let expectedValue = "Longitude:"
        let location = anyLocation()
        
        let sut = LocationDisplayModel(location: location)
        
        XCTAssertEqual(expectedValue, sut.longitudeDescription)
    }
    
    func test_longitude_returnsLogitudeAsString()  {
        let expectedLongitude = 20.232323232
        let location = Location(latitude: 13.232323232, longitude: expectedLongitude)
        
        let sut = LocationDisplayModel(location: location)
        
        XCTAssertEqual(expectedLongitude.description, sut.longitude)
    }
    
    func test_latitude_returnsLatitudeAsString()  {
        let expectedLatitude = 20.232323232
        let location = Location(latitude: expectedLatitude, longitude: 32.232323232)
        
        let sut = LocationDisplayModel(location: location)
        
        XCTAssertEqual(expectedLatitude.description, sut.latitude)
    }
    
    private func anyLocation() -> Location {
        return Location(name:"AnyName", latitude: 20.0, longitude: 30.0)
    }

}
