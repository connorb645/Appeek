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

// MARK: - Route

enum OnboardingRoute: Equatable {
    case signUp
}

// MARK: - State

struct OnboardingState: Equatable {
    var route: OnboardingRoute?
    
    static let preview = Self()
}

// MARK: - Action

enum OnboardingAction: Equatable { }

// MARK: - Environment

struct OnboardingEnvironment {
    static let preview = Self()
}

// MARK: - Reducer

let onboardingReducer = Reducer<OnboardingState, OnboardingAction, OnboardingEnvironment>.combine(
    .init { state, action, environment in
        .none
    }
)

// MARK: - View

struct OnboardingView: View {
    let store: Store<OnboardingState, OnboardingAction>
    
    var body: some View {
        WithViewStore(self.store) { viewState in
            AppeekBackgroundView {
                NavigationLink("Go To Auth", value: OnboardingRouteStack.State.signUp)
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

struct NavigationTag: Codable, Identifiable, Hashable {
    var id: String
}

extension View {
    static var navigationTag: NavigationTag {
        .init(id: String(describing: self))
    }
}
