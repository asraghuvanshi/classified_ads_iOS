//
//  APIServices.swift
//  classified_ads_iOS
//
//  Created by iOS Developer on 17/05/26.
//

import Foundation
import Combine

protocol APIServiceProtocol {
    func request<T: Decodable>(_ endpoint: APIEndpoint) -> AnyPublisher<T, APIError>
    func requestWithoutResponse(_ endpoint: APIEndpoint) -> AnyPublisher<Void, APIError>
}

class APIService: APIServiceProtocol {
    private let baseURL: String
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(baseURL: String = Constants.baseURL,
         session: URLSession = .shared,
         decoder: JSONDecoder = JSONDecoder()) {
        self.baseURL = baseURL
        self.session = session
        self.decoder = decoder
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }
    
    func request<T: Decodable>(_ endpoint: APIEndpoint) -> AnyPublisher<T, APIError> {
        do {
            let request = try endpoint.makeRequest(baseURL: baseURL)
            return session.dataTaskPublisher(for: request)
                .tryMap { data, response in
                    guard let httpResponse = response as? HTTPURLResponse else {
                        throw APIError.unknown
                    }
                    
                    switch httpResponse.statusCode {
                    case 200...299:
                        return data
                    case 401:
                        throw APIError.unauthorized
                    case 400...499:
                        throw APIError.serverError(statusCode: httpResponse.statusCode)
                    case 500...599:
                        throw APIError.serverError(statusCode: httpResponse.statusCode)
                    default:
                        throw APIError.unknown
                    }
                }
                .decode(type: T.self, decoder: self.decoder)
                .mapError { error in
                    if let apiError = error as? APIError {
                        return apiError
                    } else if error is DecodingError {
                        return APIError.decodingError
                    } else {
                        return APIError.networkError(error)
                    }
                }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error as? APIError ?? .unknown)
                .eraseToAnyPublisher()
        }
    }
    
    func requestWithoutResponse(_ endpoint: APIEndpoint) -> AnyPublisher<Void, APIError> {
        do {
            let request = try endpoint.makeRequest(baseURL: baseURL)
            return session.dataTaskPublisher(for: request)
                .tryMap { _, response in
                    guard let httpResponse = response as? HTTPURLResponse else {
                        throw APIError.unknown
                    }
                    
                    switch httpResponse.statusCode {
                    case 200...299:
                        return
                    case 401:
                        throw APIError.unauthorized
                    case 400...499:
                        throw APIError.serverError(statusCode: httpResponse.statusCode)
                    case 500...599:
                        throw APIError.serverError(statusCode: httpResponse.statusCode)
                    default:
                        throw APIError.unknown
                    }
                }
                .mapError { error in
                    if let apiError = error as? APIError {
                        return apiError
                    } else {
                        return APIError.networkError(error)
                    }
                }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error as? APIError ?? .unknown)
                .eraseToAnyPublisher()
        }
    }
}
