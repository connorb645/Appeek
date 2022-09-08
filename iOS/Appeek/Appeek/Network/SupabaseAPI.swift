//
//  API.swift
//  Appeek
//
//  Created by Connor Black on 27/06/2022.
//

import Foundation
import Supabase

typealias RequestWithMiddleware<T> = (T, RefreshMiddleware, () throws -> AuthSession)

protocol APIProtocol {
    func login(email: String, password: String) async throws -> AuthSession
    func signUp(email: String, password: String) async throws -> AuthSession
    func logout() async throws
    func resetPassword(email: String) async throws
    func refreshSession(token: String) async throws -> AuthSession
    
    func organisations(_ request: RequestWithMiddleware<UUID>) async throws -> [Organisation]
    func organisationTeamMembers(_ request: RequestWithMiddleware<UUID>) async throws -> [UserPublicDetails]
    func createUserPublicDetails(_ request: RequestWithMiddleware<UserPublicDetails.Creation>) async throws -> Void
}

struct SupabaseAPI: APIProtocol {
    private let client: SupabaseClient
    private let network: Network
    
    init(network: Network,
         urlBuilder: URLBuilder) {
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
            throw AppeekError.networkError(.noUserId)
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
            throw AppeekError.networkError(.noSession)
        }
        
        guard let idUuid = UUID(uuidString: session.user.id) else {
            try await logout()
            throw AppeekError.networkError(.noUserId)
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
            throw AppeekError.networkError(.noUserId)
        }
        let accessToken = response.accessToken
        let refreshToken = response.refreshToken
        return .init(userId: userId,
                     accessToken: accessToken,
                     refreshToken: refreshToken)
    }
    
    func organisations(_ request: RequestWithMiddleware<UUID>) async throws -> [Organisation] {
        let (user,
             refreshMiddleware,
             currentAuthSession) = request
        let relations: [UserOrganisationRelation] = try await network.get(
            .usersOrganisationRelationsForUser(user),
            refreshMiddleware: refreshMiddleware,
            currentAuthSession: currentAuthSession)
        
        let organisationIds = relations.map { $0.organisationId }
        
        let organisations: [Organisation] = try await network.get(.organisations(ids: organisationIds),
                                                                  refreshMiddleware: refreshMiddleware,
                                                                  currentAuthSession: currentAuthSession)
        
        return organisations
    }
    
    func organisationTeamMembers(_ request: RequestWithMiddleware<UUID>) async throws -> [UserPublicDetails] {
            let (organisationId,
                 refreshMiddleware,
                 currentAuthSession) = request
            
            let relations: [UserOrganisationRelation] = try await network.get(
                .usersOrganisationRelationsForOrganisation(organisationId),
                refreshMiddleware: refreshMiddleware,
                currentAuthSession: currentAuthSession)
            
            let userIds = relations.map { $0.userId }
            
            let teamMembers: [UserPublicDetails] = try await network.get(.getUserPublicDetails(ids: userIds),
                                                                         refreshMiddleware: refreshMiddleware,
                                                                         currentAuthSession: currentAuthSession)
            return teamMembers
        }
    
    func createUserPublicDetails(_ request: RequestWithMiddleware<UserPublicDetails.Creation>) async throws -> Void {
        let (details,
             refreshMiddleware,
             currentAuthSession) = request
        try await network.post(.createUserPublicDetails,
                               body: details,
                               refreshMiddleware: refreshMiddleware,
                               currentAuthSession: currentAuthSession)
    }
    
    static let preview = Self(network: Network.preview,
                           urlBuilder: URLBuilder.preview)
}
