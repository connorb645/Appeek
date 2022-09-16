//
//  OrganisationTeamMembersClient.swift
//  Appeek
//
//  Created by Connor Black on 09/09/2022.
//

import Foundation
import ComposableArchitecture
import SwiftUI

struct OrganisationTeamMembersClient {
    
    struct FetchResponse: Equatable {
        let admins: [UserPublicDetails]
        let nonAdmins: [UserPublicDetails]
        let isCurrentUserAdmin: Bool
        let currentUserId: UUID
    }
    
    var fetchTeamMembersForOrganisation: (UUID) async throws -> [UserPublicDetails]
    var fetchAdminsForOrganisation: (UUID) async throws -> [UserPublicDetails]
    var currentAuthSession: () throws -> AuthSession
    
    init(
        fetchTeamMembersForOrganisation: @escaping (UUID) async throws -> [UserPublicDetails],
        fetchAdminsForOrganisation: @escaping (UUID) async throws -> [UserPublicDetails],
        currentAuthSession: @escaping () throws -> AuthSession
    ) {
        self.fetchTeamMembersForOrganisation = fetchTeamMembersForOrganisation
        self.fetchAdminsForOrganisation = fetchAdminsForOrganisation
        self.currentAuthSession = currentAuthSession
    }
    
    func fetch(orgId: UUID) async throws -> FetchResponse {
        let admins = try await fetchAdminsForOrganisation(orgId)
        let allTeamMembers = try await fetchTeamMembersForOrganisation(orgId)
        let currentAuthSession = try currentAuthSession()
        let isCurrentUserAdmin = admins.contains { $0.userId == currentAuthSession.userId }
        
        let nonAdmins = Set(allTeamMembers).subtracting(Set(admins))
        
        return FetchResponse(
            admins: admins,
            nonAdmins: Array(nonAdmins),
            isCurrentUserAdmin: isCurrentUserAdmin,
            currentUserId: currentAuthSession.userId
        )
    }
    
    static let preview: OrganisationTeamMembersClient = Self.init(
        fetchTeamMembersForOrganisation: { _ in [] },
        fetchAdminsForOrganisation: { _ in [] },
        currentAuthSession: { .init(
            userId: .init(),
            accessToken: "",
            refreshToken: ""
        ) }
    )
}
