//
//  MockHTTPClient.swift
//  PokedexTests
//
//  Created by Guilerme Barciki   on 31/07/24.
//

import Foundation
@testable import Pokedex

final class MockHTTPClient: HTTPClient {
    var result: NetworkResult?
    
    func perform(request: URLRequest, completion: @escaping (NetworkResult) -> Void) {
        if let result = result {
            completion(result)
        }
    }
}
