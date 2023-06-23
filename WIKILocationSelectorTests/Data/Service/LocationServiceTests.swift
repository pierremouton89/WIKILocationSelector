//
//  LocationServiceTests.swift
//  WIKILocationSelectorTests
//
//  Created by Pierre Mouton on 23/06/2023.
//

import XCTest

struct LocationData: Equatable, Codable {
        
    let name: String?
    let latitude: Double
    let longitude: Double
    enum CodingKeys: String, CodingKey {
        case name
        case latitude = "lat"
        case longitude = "long"
    }
}

enum LocationResult {
    case success([LocationData])
    case failure(Error)
}

protocol LocationService {
    
    func loadLocations() async -> LocationResult
}

class LocationServiceImplementation: LocationService {
    
    
    static let DEFAULT_URL: URL = URL(string: "https://private-anon-9cd97adfe1-androidtestmobgen.apiary-mock.com/categories")!
    private let httpClient: HTTPClient
    private let requestURL: URL
    
    
    init(httpClient: HTTPClient, requestURL: URL = DEFAULT_URL) {
        self.httpClient = httpClient
        self.requestURL = requestURL
    }
    
    func loadLocations() async -> LocationResult {
        let response = await httpClient.get(from: requestURL)
        switch(response) {
        case .success((let data, _)):
            let decoder = JSONDecoder()
            if let items = try? decoder.decode([LocationData].self, from: data) {
                return .success(items)
            }
            fatalError("Could not parser data")
        case .failure(let error):
            return .failure(error)
        }
    }
}

final class LocationServiceTests: XCTestCase {

    func test_init_doesNotRequestDataFromURLs() {
        let (_, client) = createSUT()

        XCTAssertEqual(client.requestedURLs, [])
    }
    
    func test_load_requestsDataFromURL() async {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = createSUT(requestURL: url)
        
        let json = makeItemsJSON([])
        client.complete(data: json, url: url)
        _ = await sut.loadLocations()
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_load_deliversEmptyListOnValidResponseWithNoItems() async {
        let (sut, client) = createSUT()
        let json = makeItemsJSON([])
        client.complete(data: json, url: anyURL())
        
        let result = await sut.loadLocations()
        
        guard case .success(let receivedItems) = result else {
            return XCTFail("Should receive valid response with elements")
        }
        XCTAssertTrue(receivedItems.isEmpty)
    
    }
    
    func test_load_deliversItemsOnValidResponseWithItems() async {
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
        let items = [item1.model, item2.model]
        let json = makeItemsJSON([item1.json, item2.json])
        client.complete(data: json, url: anyURL())

        let result = await sut.loadLocations()

        guard case .success(let receivedItems) = result else {
            return XCTFail("Should receive valid response with elements")
        }
        XCTAssertEqual(receivedItems, items)
    }

    private static func anyURL() -> URL {
        return URL(string: "https://a-given-url.com")!
    }
    
    private func makeItem(name: String? = .none, latitude: Double, longitude: Double) -> (model: LocationData, json: [String: Any]) {
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
        return try! JSONSerialization.data(withJSONObject: items)
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
        do {
            let result = self.messages[count].result
            count += 1
            return result
        } catch {
            XCTFail("Fail")
        }
        
    }
    
    func complete(withStatusCode code: Int = 200, data: Data, at index: Int = 0, url: URL) {
        let response = HTTPURLResponse(url: url, statusCode: code, httpVersion: nil, headerFields: nil)!
        let responseMessage = (url: url , result: HTTPClient.Result.success((data, response)))
        self.messages.insert(responseMessage, at: index)
    }

}
