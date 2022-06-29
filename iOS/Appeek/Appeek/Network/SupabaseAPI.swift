//
//  API.swift
//  Appeek
//
//  Created by Connor Black on 27/06/2022.
//

import Foundation
import Supabase

protocol APIProtocol {
    func login(email: String, password: String) async throws -> AuthSession
    func signUp(email: String, password: String) async throws -> AuthSession
    func logout() async throws
}

struct SupabaseAPI: APIProtocol {
    private let client: SupabaseClient
    
    init() {
        guard let supabaseUrl = URL(string: EnvironmentKey.supabaseBaseUrl.value) else {
            fatalError(APIConfigError.invalidUrl.friendlyMessage)
        }
        self.client = .init(supabaseURL: supabaseUrl, supabaseKey: EnvironmentKey.supabaseKey.value)
    }
    
    func login(email: String, password: String) async throws -> AuthSession {
        let response = try await client.auth.signIn(email: email, password: password)
        let userId = response.user.id
        let accessToken = response.accessToken
        return .init(userId: userId, accessToken: accessToken)
    }
    
    func signUp(email: String, password: String) async throws -> AuthSession {
        let response = try await client.auth.signUp(email: email, password: password)
        guard let accessToken = response.session?.accessToken else {
            try await logout()
            throw NetworkError.noAccessToken
        }
        guard let userId = response.session?.user.id else {
            try await logout()
            throw NetworkError.noUserId
        }
        return .init(userId: userId, accessToken: accessToken)
    }
    
    func logout() async throws {
        _ = try await client.auth.signOut()
    }
}
