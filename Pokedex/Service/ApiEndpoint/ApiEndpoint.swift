//
//  ApiEndpoint.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 29/07/24.
//

import Foundation

protocol ApiEndpoint {
    var baseUrlString: String { get }
    var path: String { get }
    var method: String { get }
    var queryItems: [URLQueryItem] { get }
}

extension ApiEndpoint {
    var urlString: String {
        guard var components = URLComponents(string: baseUrlString) else {
            return ""
        }
        components.path = path
        components.queryItems = queryItems
        return components.url?.absoluteString ?? ""
    }
    
    var makeRequest: URLRequest? {
        guard let url = URL(string: urlString) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method
        return request
    }
}
