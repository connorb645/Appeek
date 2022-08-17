//
//  OrganisationClient.swift
//  Appeek
//
//  Created by Connor Black on 09/08/2022.
//

import Foundation
import ComposableArchitecture
import SwiftUI

protocol OrganisationClientProtocol {
    func usersOrganisations() -> Effect<[Organisation], AppeekError>
}

struct OrganisationClient: OrganisationClientProtocol {
    let organisations: (UUID, Middleware, () throws -> AuthSession) async throws -> [Organisation]
    let refreshMiddleware: RefreshMiddleware
    let currentAuthSession: () throws -> AuthSession
    
    func usersOrganisations() -> Effect<[Organisation], AppeekError> {
        Effect.task {
            let userId = try currentAuthSession().userId
            return try await organisations(userId,
                                           refreshMiddleware,
                                           currentAuthSession)
        }
        .mapError { $0.toAppeekError() }
        .eraseToEffect()
    }
    
    static let preview: OrganisationClientProtocol = Self.init(organisations: SupabaseAPI.preview.organisations(for:refreshMiddleware:currentAuthSession:),
                                                               refreshMiddleware: RefreshMiddleware.preview,
                                                               currentAuthSession: {
            .init(userId: UUID(), accessToken: "", refreshToken: "")
    })
}
