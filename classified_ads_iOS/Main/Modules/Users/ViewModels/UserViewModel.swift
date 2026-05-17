//
//  UserViewModel.swift
//  classified_ads_iOS
//
//  Created by iOS Developer on 17/05/26.
//

import Foundation
import Combine
import SwiftUI

enum LoadingState {
    case idle
    case loading
    case loaded
    case error(String)
}

@MainActor
class UserViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var loadingState: LoadingState = .idle
    @Published var selectedUser: User?
    
    private let apiService: APIServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    // GET: Fetch all users
    func fetchUsers() async {
        loadingState = .loading
        
        let endpoint = APIEndpoint(
            path: "/users",
            method: .get,
            headers: nil,
            queryItems: nil,
            body: nil
        )
        
        apiService.request(endpoint)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.loadingState = .error(error.localizedDescription)
                }
            } receiveValue: { [weak self] (users: [User]) in
                self?.users = users
                self?.loadingState = .loaded
            }
            .store(in: &cancellables)
    }
    
    // GET: Fetch single user
    func fetchUser(id: Int) async {
        loadingState = .loading
        
        let endpoint = APIEndpoint(
            path: "/users/\(id)",
            method: .get,
            headers: nil,
            queryItems: nil,
            body: nil
        )
        
        apiService.request(endpoint)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.loadingState = .error(error.localizedDescription)
                }
            } receiveValue: { [weak self] (user: User) in
                self?.selectedUser = user
                self?.loadingState = .loaded
            }
            .store(in: &cancellables)
    }
    
    // POST: Create new user
    func createUser(request: CreateUserRequest) async -> Bool {
        loadingState = .loading
        
        let endpoint = APIEndpoint(
            path: "/users",
            method: .post,
            headers: nil,
            queryItems: nil,
            body: request
        )
        
        return await withCheckedContinuation { continuation in
            apiService.request(endpoint)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self?.loadingState = .error(error.localizedDescription)
                        continuation.resume(returning: false)
                    }
                } receiveValue: { [weak self] (user: User) in
                    self?.users.append(user)
                    self?.loadingState = .loaded
                    continuation.resume(returning: true)
                }
                .store(in: &self.cancellables)
        }
    }
    
    // PUT: Update user
    func updateUser(id: Int, request: UpdateUserRequest) async -> Bool {
        loadingState = .loading
        
        let endpoint = APIEndpoint(
            path: "/users/\(id)",
            method: .put,
            headers: nil,
            queryItems: nil,
            body: request
        )
        
        return await withCheckedContinuation { continuation in
            apiService.request(endpoint)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self?.loadingState = .error(error.localizedDescription)
                        continuation.resume(returning: false)
                    }
                } receiveValue: { [weak self] (user: User) in
                    if let index = self?.users.firstIndex(where: { $0.id == id }) {
                        self?.users[index] = user
                    }
                    self?.loadingState = .loaded
                    continuation.resume(returning: true)
                }
                .store(in: &self.cancellables)
        }
    }
    
    // DELETE: Delete user
    func deleteUser(id: Int) async -> Bool {
        loadingState = .loading
        
        let endpoint = APIEndpoint(
            path: "/users/\(id)",
            method: .delete,
            headers: nil,
            queryItems: nil,
            body: nil
        )
        
        return await withCheckedContinuation { continuation in
            apiService.requestWithoutResponse(endpoint)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completion in
                    switch completion {
                    case .finished:
                        self?.users.removeAll { $0.id == id }
                        self?.loadingState = .loaded
                        continuation.resume(returning: true)
                    case .failure(let error):
                        self?.loadingState = .error(error.localizedDescription)
                        continuation.resume(returning: false)
                    }
                } receiveValue: { _ in }
                .store(in: &self.cancellables)
        }
    }
}
