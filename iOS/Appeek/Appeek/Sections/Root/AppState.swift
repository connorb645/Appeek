//
//  AppState.swift
//  Appeek
//
//  Created by Connor Black on 01/08/2022.
//

import ComposableArchitecture

enum AppState: Equatable {
    case organisationsListState(OrganisationsListState)
    case onboarding(OnboardingState)
    
    static let live = AppState.onboarding(.init())
}
