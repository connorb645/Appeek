//
//  AppEnvironment.swift
//  Appeek
//
//  Created by Connor Black on 01/08/2022.
//

import Foundation
import ComposableArchitecture

struct AppEnvironment {
    var validationClient: ValidationClientProtocol
    var signUpClient: SignUpClient
    var loginClient: LoginClient
    
    var resetPassword: (String) async throws -> Void
    var retrieveAuthSession: () throws -> AuthSession
    var logout: () async throws -> Void
    var clearAuthSession: () -> Void
    var usersOrganisations: () async throws -> [Organisation]
    
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var userDefaults: UserDefaults
    var encoder: JSONEncoder
    var decoder: JSONDecoder
    
    static var live: AppEnvironment {
        let userDefaults: UserDefaults = UserDefaults.standard
        let encoder: JSONEncoder = JSONEncoder()
        let decoder: JSONDecoder = JSONDecoder()
        let mainQueue: AnySchedulerOf<DispatchQueue> = .main
        
        let jsonSerializer: JsonSerializer = .init()
        
        let network: Network = .init(
            urlSession: .shared,
            jsonSerializer: jsonSerializer)
        
        let urlBuilder: URLBuilder = .init()
        let apiClient: APIProtocol = SupabaseAPI(
            network: network,
            urlBuilder: urlBuilder)
        
        let persist: (AuthSession) throws -> AuthSession = { authSession in
            let encoded = try encoder.encode(authSession)
            userDefaults.set(encoded, forKey: Constants.isLoggedInKey)
            return authSession
        }
        
        let clearAuthSession: () -> Void = {
            userDefaults.removeObject(forKey: Constants.isLoggedInKey)
        }
        
        let retrieveAuthSession: () throws -> AuthSession = {
            guard let encodedAuthSession = userDefaults.object(forKey: Constants.isLoggedInKey) as? Data,
                  let decodedAuthSession = try? decoder.decode(AuthSession?.self, from: encodedAuthSession) else {
                throw AppeekError.noAuthSession
            }
            return decodedAuthSession
        }
        
        let refreshToken: () async throws -> AuthSession = {
            let token = try retrieveAuthSession().refreshToken
            return try await apiClient.refreshSession(token: token)
        }
        
        let resetPassword: (String) async throws -> Void = { emailAddress in
            
        }
        
        let refreshMiddleware = RefreshMiddleware(
            userDefaults: userDefaults,
            decoder: decoder,
            encoder: encoder,
            currentAuthSession: retrieveAuthSession,
            refreshToken: refreshToken,
            persistAuthSession: persist)
        
        let usersOrganisations: () async throws -> [Organisation] = {
            let currentAuthSession = try retrieveAuthSession()
            return try await apiClient.organisations((currentAuthSession.userId,
                                                      refreshMiddleware,
                                                      retrieveAuthSession))
        }
        
        let validationClient: ValidationClientProtocol = ValidationClient()
        
        let signUpClient = SignUpClient(
            createUserDetails: apiClient.createUserPublicDetails(_:),
            createAccount: apiClient.signUp(email:password:),
            currentAuthSession: retrieveAuthSession,
            persist: persist,
            refreshMiddleware: refreshMiddleware)
        
        let loginClient = LoginClient(
            login: apiClient.login(email:password:),
            persist: persist)
    
        return .init(
            validationClient: validationClient,
            signUpClient: signUpClient,
            loginClient: loginClient,
            resetPassword: apiClient.resetPassword(email:),
            retrieveAuthSession: retrieveAuthSession,
            logout: apiClient.logout,
            clearAuthSession: clearAuthSession,
            usersOrganisations: usersOrganisations,
            mainQueue: mainQueue,
            userDefaults: userDefaults,
            encoder: encoder,
            decoder: decoder)
    }
}

struct Constants {
    static let isLoggedInKey = "isUserLoggedIn"
}
