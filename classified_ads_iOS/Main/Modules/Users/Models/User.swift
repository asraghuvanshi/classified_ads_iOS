//
//  User.swift
//  classified_ads_iOS
//
//  Created by iOS Developer on 17/05/26.
//


import Foundation

struct User: Codable, Identifiable, Equatable {
    let id: Int
    let name: String
    let email: String
    let username: String
    let phone: String?
    let website: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, email, username, phone, website
    }
}

// Request Models
struct CreateUserRequest: Codable {
    let name: String
    let email: String
    let username: String
    let phone: String?
    let website: String?
}

struct UpdateUserRequest: Codable {
    let name: String?
    let email: String?
    let username: String?
    let phone: String?
    let website: String?
}

// Response Models
struct APIResponse<T: Codable>: Codable {
    let status: String
    let data: T?
    let message: String?
}
