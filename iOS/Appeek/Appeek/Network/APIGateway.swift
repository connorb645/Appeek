//
//  APIGateway.swift
//  Appeek
//
//  Created by Connor Black on 03/07/2022.
//

import Foundation
import SwiftUI

protocol APIGatewayProtocol {
    func organisations(for user: UUID,
                       authenticationGateway: AuthenticationGateway) async throws -> [Organisation]
}

struct APIGateway: APIGatewayProtocol {
    private let expiredTokenCode = "PGRST301"
    let api: APIProtocol
    
    init(api: APIProtocol = SupabaseAPI.live) {
        self.api = api
    }
    
    func organisations(for user: UUID,
                       authenticationGateway: AuthenticationGateway) async throws -> [Organisation] {
        guard let currentSession = await authenticationGateway.currentSession else {
            throw AppeekError.networkError(.noSession)
        }
        do {
            return try await api.organisations(for: user, bearerToken: currentSession.accessToken)
        } catch AppeekError.networkError(.serverError(let message, let code, let details)) {
            if let code, code == expiredTokenCode {
                let newSession = try await authenticationGateway.refreshSession(token: currentSession.refreshToken)
                return try await api.organisations(for: user,
                                                   bearerToken: newSession.accessToken)
            } else {
                throw AppeekError.networkError(.serverError(message: message,
                                                            code: code,
                                                            details: details))
            }
        } catch let error {
            throw error
        }
    }
}
