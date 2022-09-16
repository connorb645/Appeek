//
//  LoginClient.swift
//  Appeek
//
//  Created by Connor Black on 03/09/2022.
//

import Foundation
import ComposableArchitecture
import SwiftUI

struct LoginClient {
    
    private let login: (String, String) async throws -> AuthSession
    private let persist: (AuthSession) async throws -> AuthSession
    
    init(
        login: @escaping (String, String) async throws -> AuthSession,
        persist: @escaping (AuthSession) async throws -> AuthSession
    ) {
        self.login = login
        self.persist = persist
    }
    
    func performLoginActions(email: String, password: String) async throws -> AuthSession {
        let authSession = try await login(email, password)
        return try await persist(authSession)
    }
    
    static let preview: LoginClient = Self.init(
        login: SupabaseAPI.preview.login(email:password:),
        persist: { $0 })
}
