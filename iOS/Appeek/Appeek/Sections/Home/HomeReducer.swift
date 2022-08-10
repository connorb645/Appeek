//
//  HomeReducer.swift
//  Appeek
//
//  Created by Connor Black on 09/08/2022.
//

import Foundation
import ComposableArchitecture
import CasePaths

typealias HomeReducer = Reducer<
    HomeStateWithRouteAndSession,
    HomeAction,
    HomeEnvironment
>

let homeReducer = HomeReducer { state, action, environment in
    switch action {
    case .onAppear:
        return .none
    case .settingsTapped:
        state.state.homeRoute = .settings
        return .none
    case let .usersOrganisationsReceived(.success(organisations)):
        return .none
    case let .usersOrganisationsReceived(.failure(error)):
        return .none
    }
}
