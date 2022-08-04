//
//  SignUpClient.swift
//  Appeek
//
//  Created by Connor Black on 19/07/2022.
//

import Foundation
import ComposableArchitecture
import SwiftUI

protocol AuthenticateClientProtocol {
    func createAccount(email: String, password: String) -> Effect<AuthSession, AppeekError>
    func login(email: String, password: String) -> Effect<AuthSession, AppeekError>
    func resetPassword(email: String) -> Effect<Bool, AppeekError>
    func persistAuthenticationState(_ session: AuthSession)
}

struct AuthenticateClient: AuthenticateClientProtocol {
    private let apiClient: APIProtocol
    private let userDefaults: UserDefaults
    
    init(apiClient: APIProtocol,
         userDefaults: UserDefaults) {
        self.apiClient = apiClient
        self.userDefaults = userDefaults
    }
    
    func createAccount(email: String, password: String) -> Effect<AuthSession, AppeekError> {
        Effect.task {
            try await apiClient.signUp(email: email, password: password)
        }
        .mapError { $0.toAppeekError() }
        .eraseToEffect()
    }
    
    func login(email: String, password: String) -> Effect<AuthSession, AppeekError> {
        Effect.task {
            try await apiClient.login(email: email, password: password)
        }
        .mapError { $0.toAppeekError() }
        .eraseToEffect()
    }
    
    func resetPassword(email: String) -> Effect<Bool, AppeekError> {
        Effect.task {
            try await apiClient.resetPassword(email: email)
            return true
        }
        .mapError { $0.toAppeekError() }
        .eraseToEffect()
    }
    
    func persistAuthenticationState(_ session: AuthSession) {
        // TODO: - Move string literal to constants file somewhere
        userDefaults.set(session, forKey: "current_session")
    }
    
    static let live = Self(apiClient: SupabaseAPI.live,
                           userDefaults: .standard)
}

// TODO: - Move this
extension Error {
    func toAppeekError() -> AppeekError {
        guard let error = self as? AppeekError else {
            return .standard(self)
        }
        return error
    }
}
