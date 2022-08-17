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
            return environment.authenticateClient.retrieveAuthSession()
            .receive(on: environment.mainQueue)
            .catchToEffect(AppAction.receivedAuthSession)

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
        case let .receivedAuthSession(.success(authSession)):
            state.route = AppRoute.home(.init())
            return .none
        case let .receivedAuthSession(.failure(error)):
            state.route = AppRoute.onboarding(.init())
            return .none
        case .onHomeTapped:
            environment.authenticateClient.clearAuthSession()
            state.route = AppRoute.onboarding(.init())
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
                                         persist: $0.authenticateClient.persist(authSession:),
                                         validationClient: $0.validationClient,
                                         mainQueue: $0.mainQueue) }
    ),
    loginReducer.pullback(
        state: \.loginStateWithRoute,
        action: /AppAction.login,
        environment: { LoginEnvironment(login: $0.authenticateClient.login(email:password:),
                                        persist: $0.authenticateClient.persist(authSession:),
                                        validate: $0.validationClient.validate(_:),
                                        mainQueue: $0.mainQueue) }
    ),
    forgotPasswordReducer.pullback(
        state: \.forgotPasswordStateWithRoute,
        action: /AppAction.forgotPassword,
        environment: { ForgotPasswordEnvironment(resetPassword: $0.authenticateClient.resetPassword(email:),
                                                 validate: $0.validationClient.validate(_:),
                                                 mainQueue: $0.mainQueue) }
    ),
    homeReducer.pullback(state: \.homeStateWithRoute,
                         action: /AppAction.homeAction,
                         environment: { HomeEnvironment(clearAuthSession: $0.authenticateClient.clearAuthSession,
                                                        usersOrganisations: $0.organisationClient.usersOrganisations,
                                                        mainQueue: $0.mainQueue) }
    )
).debug()
