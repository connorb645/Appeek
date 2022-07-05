//
//  AuthenticationGateway.swift
//  Appeek
//
//  Created by Connor Black on 27/06/2022.
//

import Foundation
import SwiftUI

protocol AuthenticationProtocol: ObservableObject {
    var currentSession: AuthSession? { get }
    
    func login(email: String, password: String) async throws -> AuthSession
    func signUp(email: String, password: String) async throws -> AuthSession
    func refreshSession(token: String) async throws -> AuthSession
    func logout() async throws
    func resetPassword(email: String) async throws
}

class AuthenticationGateway: AuthenticationProtocol {
    let api: APIProtocol
    @MainActor @AppStorage("current_auth_session", store: .standard) private(set) var currentSession: AuthSession?
    
    init(api: APIProtocol = SupabaseAPI()) {
        self.api = api
    }
    
    @MainActor func login(email: String, password: String) async throws -> AuthSession {
        let authSession = try await api.login(email: email, password: password)
        self.currentSession = authSession
        return authSession
    }
    
    @MainActor func signUp(email: String, password: String) async throws -> AuthSession {
        let authSession = try await api.signUp(email: email, password: password)
        self.currentSession = authSession
        return authSession
    }
    
    @MainActor func refreshSession(token: String) async throws -> AuthSession {
        let authSession = try await api.refreshSession(token: token)
        self.currentSession = authSession
        return authSession
    }
    
    @MainActor func logout() async throws {
        try await api.logout()
        self.currentSession = nil
    }
    
    func resetPassword(email: String) async throws {
        try await api.resetPassword(email: email)
    }
}
