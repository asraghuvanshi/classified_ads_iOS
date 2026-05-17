//
//  APIEndpoint.swift
//  classified_ads_iOS
//
//  Created by iOS Developer on 17/05/26.
//


import Foundation

struct APIEndpoint {
    let path: String
    let method: HTTPMethod
    var headers: [String: String]?
    var queryItems: [URLQueryItem]?
    var body: Encodable?
    
    func makeRequest(baseURL: String) throws -> URLRequest {
        guard var urlComponents = URLComponents(string: baseURL + path) else {
            throw APIError.invalidURL
        }
        
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // Default headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Custom headers
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Body
        if let body = body {
            do {
                request.httpBody = try JSONEncoder().encode(body)
            } catch {
                throw APIError.encodingError
            }
        }
        
        return request
    }
}
