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
    func persist(authSession: AuthSession) -> Effect<AuthSession, AppeekError>
    func persist(authSession: AuthSession) throws -> AuthSession
    func retrieveAuthSession() -> Effect<AuthSession, AppeekError>
    func retrieveAuthSession() throws -> AuthSession
    func resetPassword(email: String) -> Effect<Bool, AppeekError>
    func refreshToken() -> Effect<AuthSession, AppeekError>
    func refreshToken() async throws -> AuthSession
    func clearAuthSession()
}

struct AuthenticateClient: AuthenticateClientProtocol {
    let signUp: (String, String) async throws -> AuthSession
    let login: (String, String) async throws -> AuthSession
    let resetPassword: (String) async throws -> Void
    let refreshSession: (String) async throws -> AuthSession
    let userDefaults: UserDefaults
    let encoder: JSONEncoder
    let decoder: JSONDecoder
    
    func createAccount(email: String, password: String) -> Effect<AuthSession, AppeekError> {
        Effect.task {
            try await signUp(email, password)
        }
        .mapError { $0.toAppeekError() }
        .eraseToEffect()
    }
    
    func login(email: String, password: String) -> Effect<AuthSession, AppeekError> {
        Effect.task {
            try await login(email, password)
        }
        .mapError { $0.toAppeekError() }
        .eraseToEffect()
    }
    
    func resetPassword(email: String) -> Effect<Bool, AppeekError> {
        Effect.task {
            try await resetPassword(email)
            return true
        }
        .mapError { $0.toAppeekError() }
        .eraseToEffect()
    }
    
    func persist(authSession: AuthSession) -> Effect<AuthSession, AppeekError> {
        Effect.catching {
            try persist(authSession: authSession)
        }
        .mapError { $0.toAppeekError() }
        .eraseToEffect()
    }
    
    func persist(authSession: AuthSession) throws -> AuthSession {
        let encoded = try encoder.encode(authSession)
        userDefaults.set(encoded, forKey: Constants.isLoggedInKey)
        return authSession
    }
    
    func retrieveAuthSession() -> Effect<AuthSession, AppeekError> {
        Effect.catching {
            try retrieveAuthSession()
        }
        .mapError { $0.toAppeekError() }
        .eraseToEffect()
    }
    
    func retrieveAuthSession() throws -> AuthSession {
        guard let encodedAuthSession = userDefaults.object(forKey: Constants.isLoggedInKey) as? Data,
              let decodedAuthSession = try? decoder.decode(AuthSession?.self, from: encodedAuthSession) else {
            throw AppeekError.noAuthSession
        }
        return decodedAuthSession
    }
    
    func refreshToken() -> Effect<AuthSession, AppeekError> {
        Effect.task {
            try await refreshToken()
        }
        .mapError { $0.toAppeekError() }
        .eraseToEffect()
    }
    
    func refreshToken() async throws -> AuthSession {
        let token = try retrieveAuthSession().refreshToken
        return try await refreshSession(token)
    }
    
    func clearAuthSession() {
        userDefaults.removeObject(forKey: Constants.isLoggedInKey)
    }
    
    static let preview = Self.init(signUp: SupabaseAPI.preview.signUp(email:password:),
                                   login: SupabaseAPI.preview.login(email:password:),
                                   resetPassword: SupabaseAPI.preview.resetPassword(email:),
                                   refreshSession: SupabaseAPI.preview.refreshSession(token:),
                                   userDefaults: .standard,
                                   encoder: JSONEncoder(),
                                   decoder: JSONDecoder())
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
