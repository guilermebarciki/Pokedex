//
//  NetworkResult.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 29/07/24.
//

import Foundation

enum NetworkResult {
    case responseData(data: Data, response: HTTPURLResponse)
    case requestFailed(Error)
}
