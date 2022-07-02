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
    func resetPassword(email: String) async throws
    
    func organisations(for user: UUID, bearerToken: String) async throws -> [Organisation]
}

struct SupabaseAPI: APIProtocol {
    private let client: SupabaseClient
    private let network: Network
    
    init(network: Network = Network()) {
        guard let supabaseUrl = URL(string: EnvironmentKey.supabaseBaseUrl.value) else {
            fatalError(APIConfigError.invalidUrl.friendlyMessage)
        }
        self.client = .init(supabaseURL: supabaseUrl, supabaseKey: EnvironmentKey.supabaseKey.value)
        self.network = network
    }
    
    func login(email: String, password: String) async throws -> AuthSession {
        let response = try await client.auth.signIn(email: email, password: password)
        let uid = response.user.id
        guard let userId = UUID(uuidString: uid) else {
            try await logout()
            throw NetworkError.noUserId
        }
        let accessToken = response.accessToken
        return .init(userId: userId, accessToken: accessToken)
    }
    
    func signUp(email: String, password: String) async throws -> AuthSession {
        let response = try await client.auth.signUp(email: email, password: password)
        guard let accessToken = response.session?.accessToken else {
            try await logout()
            throw NetworkError.noAccessToken
        }
        guard let uid = response.session?.user.id,
              let userId = UUID(uuidString: uid) else {
            try await logout()
            throw NetworkError.noUserId
        }
        return .init(userId: userId, accessToken: accessToken)
    }
    
    func logout() async throws {
        _ = try await client.auth.signOut()
    }
    
    func resetPassword(email: String) async throws {
        try await client.auth.resetPasswordForEmail(email)
    }
    
    func organisations(for user: UUID,
                       bearerToken: String) async throws -> [Organisation] {
        let relations: [UserOrganisationRelation] = try await network.get(.usersOrganisationRelations(user),
                                                                         bearerToken: bearerToken)
        
        let organisationIds = relations.map { $0.organisationId }
        
        let organisations: [Organisation] = try await network.get(.organisations(ids: organisationIds),
                                                                  bearerToken: bearerToken)
        
        return organisations
    }
}
