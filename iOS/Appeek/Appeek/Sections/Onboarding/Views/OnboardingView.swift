//
//  OnboardingView.swift
//  Appeek
//
//  Created by Connor Black on 28/06/2022.
//

import SwiftUI
import ConnorsComponents
import ComposableArchitecture
import SwiftUINavigation

// MARK: - State

enum OnboardingRoute: Hashable {
    case signUp
}

struct OnboardingState: Equatable {
        
    var navigationPath: NavigationPath = .init()
    private var _signUpState: SignUpState?
    private var signUpState: SignUpState {
        get {
            _signUpState ?? .init()
        }
        set {
            self._signUpState = newValue
        }
    }
    
    var signUpStateCombined: SignUpStateCombined {
        get {
            .init(viewState: signUpState,
                  navigationPath: navigationPath)
        }
        set {
            self.signUpState = newValue.viewState
            self.navigationPath = newValue.navigationPath
        }
    }
    
    static let preview = Self()
}

// MARK: - Action

enum OnboardingAction: Equatable {
    case signUpAction(SignUpAction)
    
    case onAppear
    case navigationPathUpdated(NavigationPath)
    case signUpTapped
}

// MARK: - Environment

struct OnboardingEnvironment {
    var signUpClient: SignUpClient
    var loginClient: LoginClient
    var validationClient: ValidationClientProtocol
    var resetPassword: (String) async throws -> Void
    
    static let preview = Self(signUpClient: SignUpClient.preview,
                              loginClient: LoginClient.preview,
                              validationClient: ValidationClient.preview,
                              resetPassword: { _ in })
}

// MARK: - Reducer

let onboardingReducer = Reducer<OnboardingState, OnboardingAction, OnboardingEnvironment>.combine(
    .init { state, action, environment in
        switch action {
        case .onAppear:
            return .none
        case let .navigationPathUpdated(navigationPath):
            state.navigationPath = navigationPath
            return .none
        case .signUpTapped:
            state.navigationPath.append(OnboardingRoute.signUp)
            return .none
        default:
            return .none
        }
    },
    signUpReducer.pullback(
        state: \.signUpStateCombined,
        action: /OnboardingAction.signUpAction,
        environment: { SignUpEnvironment(signUpClient: $0.signUpClient,
                                         loginClient: $0.loginClient,
                                         validationClient: $0.validationClient,
                                         resetPassword: $0.resetPassword) }
    )
)

// MARK: - View

struct OnboardingView: View {
    let store: Store<OnboardingState, OnboardingAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            AppeekBackgroundView {
                NavigationStack(path: viewStore.binding(get: \.navigationPath,
                                                        send: OnboardingAction.navigationPathUpdated)) {
                    Button("Sign Up Now") {
                        viewStore.send(.signUpTapped)
                    }
                    .onAppear {
                        viewStore.send(.onAppear)
                    }
                    .navigationDestination(for: OnboardingRoute.self) { route in
                        switch route {
                        case .signUp:
                            SignUpView(store: self.store.scope(state: \.signUpStateCombined,
                                                               action: OnboardingAction.signUpAction))
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Preview

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(
            store: .init(
                initialState: OnboardingState.preview,
                reducer: onboardingReducer,
                environment: OnboardingEnvironment.preview
            )
        )
    }
}
