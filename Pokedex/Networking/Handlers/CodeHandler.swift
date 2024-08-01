//
//  CodeHandler.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 29/07/24.
//

import Foundation

protocol StatusCodeHandlerProtocol {
    func handleStatusCode(_ statusCode: Int) -> ApiError?
}

struct DefaultStatusCodeHandler: StatusCodeHandlerProtocol {
    func handleStatusCode(_ statusCode: Int) -> ApiError? {
        switch statusCode {
        case 200...299:
            return nil
        default:
            return .serverError(status: statusCode)
        }
    }
}
