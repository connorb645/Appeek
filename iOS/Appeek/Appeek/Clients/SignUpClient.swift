//
//  SignUpClient.swift
//  Appeek
//
//  Created by Connor Black on 26/08/2022.
//

import Foundation
import ComposableArchitecture
import SwiftUI

struct SignUpClient {
    struct SignUpResponse: Equatable {
        let authSession: AuthSession
        let userPublicDetails: UserPublicDetails
    }
    
    private let createUserDetails:
        (RequestWithMiddleware<UserPublicDetails.Creation>) async throws -> Void
    private let createAccount: (String, String) async throws -> AuthSession
    private let currentAuthSession: () throws -> AuthSession
    private let persist: (AuthSession) async throws -> AuthSession
    private let refreshMiddleware: RefreshMiddleware
    
    init(
        createUserDetails: @escaping (RequestWithMiddleware<UserPublicDetails.Creation>) async throws -> Void,
        createAccount: @escaping (String, String) async throws -> AuthSession,
        currentAuthSession: @escaping () throws -> AuthSession,
        persist: @escaping (AuthSession) async throws -> AuthSession,
        refreshMiddleware: RefreshMiddleware) {
        self.createUserDetails = createUserDetails
        self.createAccount = createAccount
        self.currentAuthSession = currentAuthSession
        self.persist = persist
        self.refreshMiddleware = refreshMiddleware
    }
    
    func performSignUpActions(
        email: String,
        password: String,
        firstName: String,
        lastName: String
    ) async throws -> Void {
        let authSession = try await createAccount(email, password)
        let userDetails = UserPublicDetails.Creation.init(id: .init(),
                                                          userId: authSession.userId,
                                                          firstName: firstName,
                                                          lastName: lastName)
        
        _ = try await persist(authSession)
        
        try await createUserDetails((userDetails,
                                     refreshMiddleware,
                                     currentAuthSession))
    }
    
    static let preview: SignUpClient = Self.init(
        createUserDetails: SupabaseAPI.preview.createUserPublicDetails(_:),
        createAccount: SupabaseAPI.preview.signUp(email:password:),
        currentAuthSession: { AuthSession.stubbed },
        persist: { $0 },
        refreshMiddleware: RefreshMiddleware.preview)
}
