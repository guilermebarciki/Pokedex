//
//  GenericMapper.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 29/07/24.
//

import Foundation

struct GenericHttpRequestMaper {
    static func map<T: Decodable>(result: NetworkResult) -> Result<T, ApiError> {
        switch result {
        case .responseData(let data, let response):
            if !(200...299).contains(response.statusCode) {
                return .failure(.serverError(status: response.statusCode))
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



