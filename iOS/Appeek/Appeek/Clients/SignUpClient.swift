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
    func persist(authSession: AuthSession,
                 in store: UserDefaults,
                 using encoder: JSONEncoder) -> Effect<AuthSession, AppeekError>
    func retrieveAuthSession(from store: UserDefaults,
                             using decoder: JSONDecoder) -> Effect<AuthSession?, AppeekError>
    func resetPassword(email: String) -> Effect<Bool, AppeekError>
}

struct AuthenticateClient: AuthenticateClientProtocol {
    private let apiClient: APIProtocol
    
    init(apiClient: APIProtocol) {
        self.apiClient = apiClient
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
    
    func persist(authSession: AuthSession,
                 in store: UserDefaults,
                 using encoder: JSONEncoder) -> Effect<AuthSession, AppeekError> {
        Effect.catching {
            let encoded = try encoder.encode(authSession)
            store.set(encoded, forKey: Constants.isLoggedInKey)
            return authSession
        }
        .mapError { $0.toAppeekError() }
        .eraseToEffect()
    }
    
    func retrieveAuthSession(from store: UserDefaults,
                             using decoder: JSONDecoder) -> Effect<AuthSession?, AppeekError> {
        Effect.catching {
            guard let encodedAuthSession = store.object(forKey: Constants.isLoggedInKey) as? Data else {
                return nil
            }
            return try? decoder.decode(AuthSession?.self, from: encodedAuthSession)
        }
        .mapError { $0.toAppeekError() }
        .eraseToEffect()
    }
    
    static let live = Self(apiClient: SupabaseAPI.live)
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
