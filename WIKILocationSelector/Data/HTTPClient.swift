//
//  HTTPClient.swift
//  WIKILocationSelector
//
//  Created by Pierre Mouton on 23/06/2023.
//

import Foundation

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
