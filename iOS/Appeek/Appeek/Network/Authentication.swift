//
//  Authentication.swift
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
    func logout() async throws
}

class Authentication: AuthenticationProtocol {
    let api: APIProtocol
    @AppStorage("current_auth_session", store: .standard) private(set) var currentSession: AuthSession?
    
    init(api: APIProtocol = SupabaseAPI()) {
        self.api = api
    }
    
    func login(email: String, password: String) async throws -> AuthSession {
        let authSession = try await api.login(email: email, password: password)
        self.currentSession = authSession
        return authSession
    }
    
    func signUp(email: String, password: String) async throws -> AuthSession {
        let authSession = try await api.signUp(email: email, password: password)
        self.currentSession = authSession
        return authSession
    }
    
    func logout() async throws {
        try await api.logout()
        self.currentSession = nil
    }
}
