//
//  LocationServiceTests.swift
//  WIKILocationSelectorTests
//
//  Created by Pierre Mouton on 23/06/2023.
//

import XCTest
@testable import WIKILocationSelector


final class LocationServiceTests: XCTestCase {

    func test_init_doesNotRequestDataFromURLs() {
        let (_, client) = createSUT()

        XCTAssertEqual(client.requestedURLs, [])
    }
    
    func test_loadLocations_requestsDataFromURL() async {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = createSUT(requestURL: url)
        
        let json = makeItemsJSON([])
        client.complete(data: json, url: url)
        do {
            _ = try await sut.loadLocations()
            XCTAssertEqual(client.requestedURLs, [url])
        } catch {
            XCTFail("Did not expect thrown \(error)")
        }
    }
    
    func test_lloadLocations_deliversEmptyListOnValidResponseWithNoItems() async {
        let (sut, client) = createSUT()
        let json = makeItemsJSON([])
        client.complete(data: json, url: anyURL())
        
        
        do {
            let result = try await sut.loadLocations()
            XCTAssertTrue(result.isEmpty)
        } catch {
            XCTFail("Did not expect thrown \(error)")
        }
    
    }
    
    func test_loadLocations_deliversItemsOnValidResponseWithItems() async {
        let (sut, client) = createSUT()

        let item1 = makeItem(
            name: "Location1",
            latitude: 52.3547498,
            longitude: 4.8339215
        )


        let item2 = makeItem(
            latitude: 40.4380638,
            longitude: 3.7495758
        )
        let expectedResult = [item1.model, item2.model]
        let json = makeItemsJSON([item1.json, item2.json])
        client.complete(data: json, url: anyURL())

        do {
            let result = try await sut.loadLocations()
            XCTAssertEqual(expectedResult, result)
        } catch {
            XCTFail("Did not expect thrown \(error)")
        }
    }
    

    private static func anyURL() -> URL {
        return URL(string: "https://a-given-url.com")!
    }
    
    private func makeItem(name: String? = .none, latitude: Decimal, longitude: Decimal) -> (model: LocationData, json: [String: Any]) {
        let item = LocationData(name: name, latitude: latitude, longitude: longitude)
        
        var json = [String : Any]()
        if let name = name {
            json["name"] = name
        }
        json["lat"] = latitude
        json["long"] = longitude
        
        return (item, json)
    }
    
    private func createSUT(requestURL: URL = anyURL()) -> (LocationService, HTTPClientSpy) {
        let client = HTTPClientSpy()
        let service = LocationServiceImplementation(httpClient: client, requestURL: requestURL)
        return(service, client)
    }
    private func makeItemsJSON(_ items: [[String: Any]]) -> Data {
        return try! JSONSerialization.data(withJSONObject: ["locations": items])
    }
    
    private func anyURL() -> URL {
        return URL(string: "https://a-given-url.com")!
    }
    
}

        
class HTTPClientSpy: HTTPClient {
    typealias ResponseMessage = (url: URL, result: HTTPClient.Result)
    private var messages = [ResponseMessage]()
    private var count = 0
    
    var requestedURLs: [URL] {
        return messages.map { $0.url }
    }
    
    
    func get(from url: URL) async -> HTTPClient.Result {
        let result = self.messages[count].result
        count += 1
        return result 
    }
    
    func complete(withStatusCode code: Int = 200, data: Data, at index: Int = 0, url: URL) {
        let response = HTTPURLResponse(url: url, statusCode: code, httpVersion: nil, headerFields: nil)!
        let responseMessage = (url: url , result: HTTPClient.Result.success((data, response)))
        self.messages.insert(responseMessage, at: index)
    }

}
