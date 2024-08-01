//
//  MockHttpRequestMapper.swift
//  PokedexTests
//
//  Created by Guilerme Barciki   on 31/07/24.
//

import Foundation
@testable import Pokedex

class MockHttpRequestMapper: HttpRequestMapperProtocol {
    var mockResult: Any?
    
    func map<T: Decodable>(result: NetworkResult) -> Result<T, ApiError> {
        
        if let result = mockResult as? Result<T, ApiError> {
            return result
        }
        return .failure(.invalidRequest)
    }
}
