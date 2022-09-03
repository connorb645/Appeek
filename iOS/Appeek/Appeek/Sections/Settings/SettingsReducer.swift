//
//  SettingsReducer.swift
//  Appeek
//
//  Created by Connor Black on 18/08/2022.
//

import Foundation
import ComposableArchitecture
import CasePaths

typealias SettingsReducer = Reducer<
    SettingsStateWithRoute,
    SettingsAction,
    SettingsEnvironment
>

let settingsReducer = SettingsReducer { state, action, environment in
    switch action {
    case .logoutTapped:
        state.state.isLoading = true
        return .task {
            await .logoutResponseReceived(TaskResult {
                try await environment.logout()
            })
        }
    case .logoutResponseReceived(.success):
        environment.clearAuthSession()
        state.state.homeRoute = nil
        return .task {
            await environment.delay(0.33)
            return .delayEnded
        }
    case let .logoutResponseReceived(.failure(error)):
        environment.clearAuthSession()
        state.state.homeRoute = nil
        return .task {
            await environment.delay(0.33)
            return .delayEnded
        }
    case .delayEnded:
        state.route = AppRoute.onboarding(.init())
        return .none
    }
}

func delay(for time: TimeInterval) async {
    let nSecs = time * Double(NSEC_PER_SEC)
    try? await Task.sleep(nanoseconds: UInt64(nSecs))
}
