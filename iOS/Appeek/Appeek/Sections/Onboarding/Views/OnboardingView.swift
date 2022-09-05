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

struct OnboardingState: Equatable {
    struct NavigationOptions {
        struct SignUpView: Hashable {}
    }
    
    var signUpState: SignUpState?
    
//    var navigationPath: NavigationPath = .init()
    
    static let preview = Self()
}

// MARK: - Action

enum OnboardingAction: Equatable {
    case signUpAction(SignUpAction)
    
    case onAppear
    case signUpStateUpdated(SignUpState?)
}

// MARK: - Environment

struct OnboardingEnvironment {
    var signUpClient: SignUpClient
    var validationClient: ValidationClientProtocol
    
    static let preview = Self(signUpClient: SignUpClient.preview,
                              validationClient: ValidationClient.preview)
}

// MARK: - Reducer

let onboardingReducer = Reducer<OnboardingState, OnboardingAction, OnboardingEnvironment>.combine(
    .init { state, action, environment in
        switch action {
        case .onAppear:
            return .none
        case let .signUpStateUpdated(signUpState):
            state.signUpState = signUpState
            return .none
        default:
            return .none
        }
    },
    signUpReducer.optional().pullback(
        state: \.signUpState,
        action: /OnboardingAction.signUpAction,
        environment: { SignUpEnvironment(signUpClient: $0.signUpClient,
                                         validationClient: $0.validationClient) }
    )
)

// MARK: - View

struct OnboardingView: View {
    let store: Store<OnboardingState, OnboardingAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                AppeekBackgroundView {

                    NavigationLink(unwrapping: viewStore.binding(get: \.signUpState,
                                                                 send: OnboardingAction.signUpStateUpdated)) { $signUpState in
                        SignUpView(store: self.store.scope(state: { _ in $signUpState.wrappedValue },
                                                           action: OnboardingAction.signUpAction))
                    } onNavigate: { isActive in
                        viewStore.send(.signUpStateUpdated(isActive ? .init() : nil))
                    } label: {
                        Text("Sign Up Now")
                    }

                    
//                    NavigationLink(unwrapping: viewState.signUpState,
//                                   destination: { $ in
//                        <#code#>
//                    },
//                                   onNavigate: {  },
//                                   label: Text("Go to auth"))
//                    NavigationLink("Go to auth", value: OnboardingState.NavigationOptions.SignUpView())
                }
                .onAppear {
                    viewStore.send(.onAppear)
                }
//                .navigationDestination(for: OnboardingState.NavigationOptions.SignUpView.self) { _ in
//                    SignUpView(store: self.store.scope(state: <#T##(OnboardingState) -> ChildState#>,
//                                                       action: <#T##(ChildAction) -> OnboardingAction#>))
//                }
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
