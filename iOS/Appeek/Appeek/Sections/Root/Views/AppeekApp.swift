//
//  AppeekApp.swift
//  Appeek
//
//  Created by Connor Black on 27/06/2022.
//

import SwiftUI
import ComposableArchitecture
import CasePaths

// MARK: - Route

enum AppRoute: Equatable {
    case onboarding(OnboardingRouteStack)
    case home(HomeRouteStack)
}

// MARK: - State

struct AppState: Equatable {
    var onboarding: OnboardingState
    var signUp: SignUpState
    
    var route: AppRoute
    
    static let live = Self(onboarding: OnboardingState(),
                           signUp: SignUpState(),
                           route: .onboarding(.init()))
    
    static let deepLinked = Self(onboarding: OnboardingState(),
                                 signUp: SignUpState(),
                                 route: .onboarding(OnboardingRouteStack.SignUpState))
}

// MARK: - Action

enum AppAction: Equatable {
    case onboarding(OnboardingAction)
    case signUp(SignUpAction)
    
    case onAppear
    case onboardingNavigationPathChanged(NavigationPath)
    case homeNavigationPathChanged(NavigationPath)
}

// MARK: - Environment

struct AppEnvironment {
    var authenticateClient: AuthenticateClientProtocol
    var validationClient: ValidationClientProtocol
    
    var mainQueue: AnySchedulerOf<DispatchQueue>

    static let live = Self(
        authenticateClient: AuthenticateClient.live,
        validationClient: ValidationClient.live,
        mainQueue: .main
    )
}

// MARK: - Reducer

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    .init { state, action, environment in
        switch action {
        case .onAppear:
            return .none
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
        state: \.signUp,
        action: /AppAction.signUp,
        environment: { SignUpEnvironment(authenticateClient: $0.authenticateClient,
                                         validationClient: $0.validationClient,
                                         mainQueue: $0.mainQueue) }
    )
)

// MARK: - View

@main
struct AppeekApp: App {
    var body: some Scene {
        WindowGroup {
            RootView(
                store: .init(
                    initialState: .live,
                    reducer: appReducer,
                    environment: .live
                )
            )
        }
    }
}

struct RootView: View {
    let store: Store<AppState, AppAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            switch viewStore.state.route {
            case .onboarding:
                NavigationStack(
                    path: viewStore.binding { appState in
                        ((/AppRoute.onboarding).extract(from: appState.route) ?? .init()).navigationPath
                    } send: { localState in
                        AppAction.onboardingNavigationPathChanged(localState)
                    }) {
                        OnboardingView(store: self.store.scope(state: \.onboarding,
                                                               action: AppAction.onboarding))
                        .navigationDestination(for: OnboardingRouteStack.State.self) { state in
                            switch state {
                            case .signUp:
                                SignUpView(store: self.store.scope(state: \.signUp,
                                                                   action: AppAction.signUp))
                            }
                        }
                }
            case .home:
                NavigationStack(
                    path: viewStore.binding { appState in
                        ((/AppRoute.home).extract(from: appState.route) ?? .init()).navigationPath
                    } send: { localState in
                        AppAction.homeNavigationPathChanged(localState)
                    }) {
                        Text("Home")
                }
            }
        }
    }
}

// MARK: - Preview

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(
            store: .init(
                initialState: .live,
                reducer: appReducer,
                environment: .live
            )
        )
    }
}
