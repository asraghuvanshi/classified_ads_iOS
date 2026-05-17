//
//  APIError.swift
//  classified_ads_iOS
//
//  Created by iOS Developer on 17/05/26.
//

import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case encodingError
    case networkError(Error)
    case serverError(statusCode: Int)
    case unauthorized
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError:
            return "Failed to decode response"
        case .encodingError:
            return "Failed to encode request"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .serverError(let statusCode):
            return "Server error with status code: \(statusCode)"
        case .unauthorized:
            return "Unauthorized access"
        case .unknown:
            return "Unknown error occurred"
        }
    }
}
