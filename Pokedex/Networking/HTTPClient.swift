//
//  HTTPClient.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 29/07/24.
//

import Foundation

protocol HTTPClient {
    func perform(request: URLRequest, completion: @escaping (NetworkResult) -> Void)
}

extension URLSession: HTTPClient {
    
    func perform(request: URLRequest, completion: @escaping (NetworkResult) -> Void) {
        
        struct InvalidHTTPResponseError: Error {}
        
        let task = dataTask(with: request) { data, response, error in
            if let error {
                completion(.requestFailed(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.requestFailed(InvalidHTTPResponseError()))
                return
            }
            
            guard let data else {
                completion(.requestFailed(InvalidHTTPResponseError()))
                return
            }
            completion(.responseData(data: data, response: httpResponse))
        }
        task.resume()
    }
    
}
