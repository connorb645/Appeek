//
//  AuthenticationGateway.swift
//  Appeek
//
//  Created by Connor Black on 27/06/2022.
//

import Foundation
import SwiftUI

class AuthenticationGateway: ObservableObject {
    let api: APIProtocol
    @MainActor @AppStorage("current_auth_session", store: .standard) private(set) var currentSession: AuthSession?
    
    init(api: APIProtocol = SupabaseAPI.preview) {
        self.api = api
    }
    
    @MainActor func login(email: String, password: String, updateCurrentSession: Bool = true) async throws -> AuthSession {
        let authSession = try await api.login(email: email, password: password)
        if updateCurrentSession {
            self.currentSession = authSession
        }
        return authSession
    }
    
    @MainActor func signUp(email: String, password: String, updateCurrentSession: Bool = true) async throws -> AuthSession {
        let authSession = try await api.signUp(email: email, password: password)
        if updateCurrentSession {
            self.currentSession = authSession
        }
        return authSession
    }
    
    @MainActor func refreshSession(token: String, updateCurrentSession: Bool = true) async throws -> AuthSession {
        let authSession = try await api.refreshSession(token: token)
        if updateCurrentSession {
            self.currentSession = authSession
        }
        return authSession
    }
    
    @MainActor func logout(updateCurrentSession: Bool = true) async throws {
        try await api.logout()
        if updateCurrentSession {
            self.currentSession = nil
        }
    }
    
    func resetPassword(email: String) async throws {
        try await api.resetPassword(email: email)
    }
    
    @MainActor func removeCurrentSession() {
        self.currentSession = nil
    }
}
