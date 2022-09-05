//
//  AppeekApp.swift
//  Appeek
//
//  Created by Connor Black on 27/06/2022.
//

import SwiftUI
import ComposableArchitecture
import CasePaths

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
            SwitchStore(self.store) {
                CaseLet(state: /AppState.home,
                        action: AppAction.homeAction) { store in
                    HomeView(store: store)
                }
                CaseLet(state: /AppState.onboarding,
                        action: AppAction.onboardingAction) { store in
                    OnboardingView(store: store)
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
            
//            Group {
                
//                IfLetStore(self.store.scope(state: \.homeState,
//                                            action: AppAction.homeAction)) { store in
//                    HomeView(store: store)
//                } else: {
//                    IfLetStore(self.store.scope(state: \.onboardingState,
//                                                action: AppAction.onboarding)) { store in
//                        Text("Onboarding")
//                    } else: {
//                        Text("Unimplemented State")
//                    }
//                }
                
//                switch viewStore.state._route {
//                case .home(let homeState):
//                    HomeView(store: self.store.scope(state: \.homeState,
//                                                     action: AppAction.homeAction))
//                case .onboarding(let onboardingState):
//                    Text("Onboarding")
//                case .none:
//                    Text("Yeaahhhhh ths is that nil case...")
//                }
                
                
//                switch viewStore.state.route {
//                case .onboarding:
//                    NavigationStack(
//                        path: viewStore.binding { appState in
//                            ((/AppRoute.onboarding).extract(from: appState.route) ?? .init()).navigationPath
//                        } send: { localState in
//                            AppAction.onboardingNavigationPathChanged(localState)
//                        }) {
//                            OnboardingView(store: self.store.scope(state: \.onboarding,
//                                                                   action: AppAction.onboarding))
//                            .navigationDestination(for: OnboardingRouteStack.State.self) { state in
//                                switch state {
//                                case .signUp:
//                                    SignUpView(store: self.store.scope(state: \.signUpStateWithRoute,
//                                                                       action: AppAction.signUp))
//                                case .login:
//                                    LoginView(store: self.store.scope(state: \.loginStateWithRoute,
//                                                                      action: AppAction.login))
//                                case .forgotPassword:
//                                    ForgotPasswordView(store: self.store.scope(state: \.forgotPasswordStateWithRoute,
//                                                                               action: AppAction.forgotPassword))
//                                }
//                            }
//                    }
//                case .home:
//                    NavigationStack(
//                        path: viewStore.binding { appState in
//                            ((/AppRoute.home).extract(from: appState.route) ?? .init()).navigationPath
//                        } send: { localState in
//                            AppAction.homeNavigationPathChanged(localState)
//                        }) {
//                            HomeView(store: self.store.scope(state: \.homeStateWithRoute,
//                                                             action: AppAction.homeAction))
//                    }
//                }
//            }
            
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
