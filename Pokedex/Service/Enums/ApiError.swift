//
//  ApiError.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 29/07/24.
//

import Foundation

enum ApiError: Error {
    case serverError(status: Int)
    case apiError(error: Error)
    case invalidRequest
    case decodingError
}
