//
//  AppEnvironment.swift
//  Appeek
//
//  Created by Connor Black on 01/08/2022.
//

import ComposableArchitecture

struct AppEnvironment {
    var authenticateClient: AuthenticateClientProtocol
    var validationClient: ValidationClientProtocol
    var organisationClient: OrganisationClientProtocol
    
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
        
        let authenticateClient: AuthenticateClientProtocol = AuthenticateClient(
            signUp: apiClient.signUp(email:password:),
            login: apiClient.login(email:password:),
            resetPassword: apiClient.resetPassword(email:),
            refreshSession: apiClient.refreshSession(token:),
            userDefaults: userDefaults,
            encoder: encoder,
            decoder: decoder)
        
        let refreshMiddleware = RefreshMiddleware(
            userDefaults: userDefaults,
            decoder: decoder,
            encoder: encoder,
            currentAuthSession: authenticateClient.retrieveAuthSession,
            refreshToken: authenticateClient.refreshToken,
            persistAuthSession: authenticateClient.persist(authSession:))
        
        let validationClient: ValidationClientProtocol = ValidationClient()
        
        let organisationClient: OrganisationClientProtocol = OrganisationClient(
            organisations: apiClient.organisations(for:refreshMiddleware:currentAuthSession:),
            refreshMiddleware: refreshMiddleware,
            currentAuthSession: authenticateClient.retrieveAuthSession)
    
        
        return .init(
            authenticateClient: authenticateClient,
            validationClient: validationClient,
            organisationClient: organisationClient,
            mainQueue: mainQueue,
            userDefaults: userDefaults,
            encoder: encoder,
            decoder: decoder)
    }
}

struct Constants {
    static let isLoggedInKey = "isUserLoggedIn"
}
