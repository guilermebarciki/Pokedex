//
//  ApiEndpoint.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 29/07/24.
//

import Foundation

protocol ApiEndpoint {
    var urlString: String { get }
    var method: String { get }
}

extension ApiEndpoint {
    var makeRequest: URLRequest? {
        guard let url = URL(string: urlString) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method
        return request
    }
}
