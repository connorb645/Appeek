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
    SettingsStateCombined,
    SettingsAction,
    SettingsEnvironment
>

let settingsReducer = SettingsReducer { state, action, environment in
    switch action {
    case .logoutTapped:
        state.viewState.isLoading = true
        return .task {
            await .logoutResponseReceived(TaskResult {
                try await environment.logout()
            })
        }
    case .logoutResponseReceived(.success):
        environment.clearAuthSession()
        return .task {
            .loggedOut
        }
    case let .logoutResponseReceived(.failure(error)):
        environment.clearAuthSession()
        return .task {
            .loggedOut
        }
    case .loggedOut:
        return .none
    case .dismissScreenTapped:
        return .none
    }
}

func delay(for time: TimeInterval) async {
    let nSecs = time * Double(NSEC_PER_SEC)
    try? await Task.sleep(nanoseconds: UInt64(nSecs))
}
