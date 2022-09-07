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
