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
    func refreshSession(token: String) async throws -> AuthSession
    
    func organisations(for user: UUID, bearerToken: String) async throws -> [Organisation]
}

struct SupabaseAPI: APIProtocol {
    private let client: SupabaseClient
    private let network: Network
    
    init(network: Network = Network(),
         urlBuilder: URLBuilder = URLBuilder()) {
        guard let url = try? urlBuilder.build(baseUrl: EnvironmentKey.supabaseBaseUrl.value) else {
            fatalError(APIConfigError.invalidUrl.friendlyMessage)
        }
        self.client = .init(supabaseURL: url,
                            supabaseKey: EnvironmentKey.supabaseKey.value)
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
        let refreshToken = response.refreshToken
        return .init(userId: userId,
                     accessToken: accessToken,
                     refreshToken: refreshToken)
    }
    
    func signUp(email: String, password: String) async throws -> AuthSession {
        let response = try await client.auth.signUp(email: email, password: password)
        
        guard let session = response.session else {
            try await logout()
            throw NetworkError.noSession
        }
        
        guard let idUuid = UUID(uuidString: "session.user.id") else {
            try await logout()
            throw NetworkError.noUserId
        }

        return .init(userId: idUuid,
                     accessToken: session.accessToken,
                     refreshToken: session.refreshToken)
    }
    
    func logout() async throws {
        _ = try await client.auth.signOut()
    }
    
    func resetPassword(email: String) async throws {
        try await client.auth.resetPasswordForEmail(email)
    }
    
    func refreshSession(token: String) async throws -> AuthSession {
        let response = try await client.auth.refreshSession(refreshToken: token)
        let uid = response.user.id
        guard let userId = UUID(uuidString: uid) else {
            try await logout()
            throw NetworkError.noUserId
        }
        let accessToken = response.accessToken
        let refreshToken = response.refreshToken
        return .init(userId: userId,
                     accessToken: accessToken,
                     refreshToken: refreshToken)
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
