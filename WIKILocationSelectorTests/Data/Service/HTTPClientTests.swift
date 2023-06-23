//
//  HTTPClient.swift
//  WIKILocationSelectorTests
//
//  Created by Pierre Mouton on 22/06/2023.
//

import XCTest

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    func get(from url: URL) async -> Result
}

public class URLSessionHTTPClient: HTTPClient {
    
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    private struct UnexpectedValuesRepresentation: Error {}
    
    public func get(from url: URL) async -> HTTPClient.Result {
        do {
            let (data, response) = try await session.data(from: url)
            if let response = response as? HTTPURLResponse {
                return .success((data, response))
            } else {
                return .failure(UnexpectedValuesRepresentation())
            }
        } catch {
            return .failure(error)
        }
    }
    
}


final class HTTPClientTests: XCTestCase {

    override func setUp() {
            super.setUp()
            URLProtocolStub.startInterceptingRequests()
        }
        
        override func tearDown() {
            super.tearDown()
            
            URLProtocolStub.stopInterceptingRequests()
        }
       
    func test_getFromURL_performsGETRequestWithURL() async {
        let url = anyURL()
    
        URLProtocolStub.observeRequests { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, "GET")
        }
        URLProtocolStub.stub(data: nil, response: nil, error: anyNSError())

        _ = await makeSUT().get(from: url)

    }

    func test_getFromURL_failsOnRequestError() async {
        let requestError = anyNSError()

        let receivedError = await resultErrorFor(data: nil, response: nil, error: requestError)

        XCTAssertEqual((receivedError as? NSError)?.localizedDescription , requestError.localizedDescription)
    }


    func test_getFromURL_succeedsOnHTTPURLResponseWithData() async {
        let data = anyData()
        let response = anyHTTPURLResponse()

        let receivedValues = await resultValuesFor(data: data, response: response, error: nil)

        XCTAssertEqual(receivedValues?.data, data)
        XCTAssertEqual(receivedValues?.response.url, response.url)
        XCTAssertEqual(receivedValues?.response.statusCode, response.statusCode)
    }

    func test_getFromURL_succeedsWithEmptyDataOnHTTPURLResponseWithNilData() async {
        let response = anyHTTPURLResponse()

        let receivedValues = await resultValuesFor(data: nil, response: response, error: nil)

        let emptyData = Data()
        XCTAssertEqual(receivedValues?.data, emptyData)
        XCTAssertEqual(receivedValues?.response.url, response.url)
        XCTAssertEqual(receivedValues?.response.statusCode, response.statusCode)
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> HTTPClient {
        let sut = URLSessionHTTPClient()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

    private func resultValuesFor(data: Data?, response: URLResponse?, error: Error?, file: StaticString = #file, line: UInt = #line) async -> (data: Data, response: HTTPURLResponse)? {
        let result = await resultFor(data: data, response: response, error: error, file: file, line: line)

        switch result {
        case let .success((data, response)):
            return (data, response)
        default:
            XCTFail("Expected success, got \(result) instead", file: file, line: line)
            return nil
        }
    }

    private func resultErrorFor(data: Data?, response: URLResponse?, error: Error?, file: StaticString = #file, line: UInt = #line) async -> Error? {
        let result = await resultFor(data: data, response: response, error: error, file: file, line: line)

        switch result {
        case let .failure(error):
            return error
        default:
            XCTFail("Expected failure, got \(result) instead", file: file, line: line)
            return nil
        }
    }

    private func resultFor(data: Data?, response: URLResponse?, error: Error?, file: StaticString = #file, line: UInt = #line) async -> HTTPClient.Result {
        URLProtocolStub.stub(data: data, response: response, error: error)
        let sut = makeSUT(file: file, line: line)
        
        return await sut.get(from: anyURL())

    }

        private func anyData() -> Data {
            return Data("any data".utf8)
        }

        private func anyHTTPURLResponse() -> HTTPURLResponse {
            return HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!
        }

        private func nonHTTPURLResponse() -> URLResponse {
            return URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
        }
        
        private class URLProtocolStub: URLProtocol {
            private static var stub: Stub?
            private static var requestObserver: ((URLRequest) -> Void)?
            
            private struct Stub {
                let data: Data?
                let response: URLResponse?
                let error: Error?
            }
            
            static func stub(data: Data?, response: URLResponse?, error: Error?) {
                stub = Stub(data: data, response: response, error: error)
            }
            
            static func observeRequests(observer: @escaping (URLRequest) -> Void) {
                requestObserver = observer
            }
            
            static func startInterceptingRequests() {
                URLProtocol.registerClass(URLProtocolStub.self)
            }
            
            static func stopInterceptingRequests() {
                URLProtocol.unregisterClass(URLProtocolStub.self)
                stub = nil
                requestObserver = nil
            }
            
            override class func canInit(with request: URLRequest) -> Bool {
                requestObserver?(request)
                return true
            }
            
            override class func canonicalRequest(for request: URLRequest) -> URLRequest {
                return request
            }
            
            override func startLoading() {
                if let data = URLProtocolStub.stub?.data {
                    client?.urlProtocol(self, didLoad: data)
                }
                
                if let response = URLProtocolStub.stub?.response {
                    client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                }
                
                if let error = URLProtocolStub.stub?.error {
                    client?.urlProtocol(self, didFailWithError: error)
                }
                
                client?.urlProtocolDidFinishLoading(self)
            }
            
            override func stopLoading() {}
        }
}

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}
