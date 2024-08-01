//
//  GenericMapper.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 29/07/24.
//

import Foundation

protocol HttpRequestMapperProtocol {
    func map<T: Decodable>(result: NetworkResult) -> Result<T, ApiError>
}

struct HttpRequestMaper: HttpRequestMapperProtocol {
    private let statusCodeHandler: StatusCodeHandlerProtocol
    
    init(statusCodeHandler: StatusCodeHandlerProtocol = DefaultStatusCodeHandler()) {
        self.statusCodeHandler = statusCodeHandler
    }
    
    func map<T: Decodable>(result: NetworkResult) -> Result<T, ApiError> {
        switch result {
        case .responseData(let data, let response):
            if let error = statusCodeHandler.handleStatusCode(response.statusCode) {
                return .failure(error)
            }
            do {
                let decodedResult = try JSONDecoder().decode(T.self, from: data)
                return .success(decodedResult)
            } catch {
                return .failure(.decodingError)
            }
        case .requestFailed(let error):
            return .failure(.apiError(error: error))
        }
    }
}
