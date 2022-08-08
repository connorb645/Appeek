//
//  AppReducer.swift
//  Appeek
//
//  Created by Connor Black on 01/08/2022.
//

import ComposableArchitecture
import CasePaths
import Combine

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    Reducer { state, action, environment in
        switch action {
        case .onAppear:
            return environment.authenticateClient.retrieveAuthSession(from: environment.userDefaults,
                                                                      using: environment.decoder)
            .receive(on: environment.mainQueue)
            .catchToEffect(AppAction.currentAuthSessionPossiblyReceived)

        case .onboardingNavigationPathChanged(let navigationPath):
            var currentRoute = (/AppRoute.onboarding).extract(from: state.route) ?? .init()
            currentRoute.navigationPath = navigationPath
            state.route = (/AppRoute.onboarding).embed(currentRoute)
            return .none
        case .homeNavigationPathChanged(let navigationPath):
            var currentRoute = (/AppRoute.home).extract(from: state.route) ?? .init()
            currentRoute.navigationPath = navigationPath
            state.route = (/AppRoute.home).embed(currentRoute)
            return .none
        case let .currentAuthSessionPossiblyReceived(.success(authSession)):
            let isLoggedIn = authSession != nil
            state.route = isLoggedIn ? AppRoute.home(.init()) : AppRoute.onboarding(.init())
            return .none
        case let .currentAuthSessionPossiblyReceived(.failure(error)):
            print(error.friendlyMessage)
            return .none
        default:
            return .none
        }
    },
    onboardingReducer.pullback(
        state: \.onboarding,
        action: /AppAction.onboarding,
        environment: { _ in .init() }
    ),
    signUpReducer.pullback(
        state: \.signUpStateWithRoute,
        action: /AppAction.signUp,
        environment: { SignUpEnvironment(createAccount: $0.authenticateClient.createAccount(email:password:),
                                         persist: $0.authenticateClient.persist(authSession:in:using:),
                                         validationClient: $0.validationClient,
                                         mainQueue: $0.mainQueue,
                                         userDefaults: $0.userDefaults,
                                         encoder: $0.encoder,
                                         decoder: $0.decoder) }
    ),
    loginReducer.pullback(
        state: \.loginStateWithRoute,
        action: /AppAction.login,
        environment: { LoginEnvironment(login: $0.authenticateClient.login(email:password:),
                                        persist: $0.authenticateClient.persist(authSession:in:using:),
                                        validate: $0.validationClient.validate(_:),
                                        mainQueue: $0.mainQueue,
                                        userDefaults: $0.userDefaults,
                                        encoder: $0.encoder,
                                        decoder: $0.decoder) }
    ),
    forgotPasswordReducer.pullback(
        state: \.forgotPasswordStateWithRoute,
        action: /AppAction.forgotPassword,
        environment: { ForgotPasswordEnvironment(resetPassword: $0.authenticateClient.resetPassword(email:),
                                                 validate: $0.validationClient.validate(_:),
                                                 mainQueue: $0.mainQueue) }
    )
)
