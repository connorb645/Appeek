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
    func usersOrganisations(_ usersId: UUID, bearerToken: String) -> Effect<[Organisation], AppeekError>
}

struct OrganisationClient: OrganisationClientProtocol {
    private let apiClient: APIProtocol
    
    init(apiClient: APIProtocol) {
        self.apiClient = apiClient
    }
    
    // TODO: - Need to figure out how to refresh the token if it has expired
    func usersOrganisations(_ usersId: UUID, bearerToken: String) -> Effect<[Organisation], AppeekError> {
        Effect.task {
            try await apiClient.organisations(for: usersId, bearerToken: bearerToken)
        }
        .mapError { $0.toAppeekError() }
        .eraseToEffect()
    }
    
    static let live = Self(apiClient: SupabaseAPI.live)
}
