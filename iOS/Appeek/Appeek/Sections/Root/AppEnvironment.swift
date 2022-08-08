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
    
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var userDefaults: UserDefaults
    var encoder: JSONEncoder
    var decoder: JSONDecoder

    static let live = Self(
        authenticateClient: AuthenticateClient.live,
        validationClient: ValidationClient.live,
        mainQueue: .main,
        userDefaults: UserDefaults.standard,
        encoder: JSONEncoder(),
        decoder: JSONDecoder()
    )
}

struct Constants {
    static let isLoggedInKey = "isUserLoggedIn"
}
