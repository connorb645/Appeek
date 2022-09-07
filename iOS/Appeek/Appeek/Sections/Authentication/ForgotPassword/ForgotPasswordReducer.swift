//
//  ForgotPasswordReducer.swift
//  Appeek
//
//  Created by Connor Black on 01/08/2022.
//

import Foundation
import ComposableArchitecture
import CasePaths

typealias ForgotPasswordReducer = Reducer<
    ForgotPasswordStateCombined,
    ForgotPasswordAction,
    ForgotPasswordEnvironment
>

let forgotPasswordReducer = ForgotPasswordReducer { state, action, environment in
    switch action {
    case let .onEmailChanged(value):
        state.viewState.emailAddress = value
        return .none
    case .submitTapped:
        return .task { [state] in
            await .submissionResponse(TaskResult {
                guard environment.validate(
                    (state.viewState.emailAddress, ValidationField.email)
                ) else {
                    throw AppeekError.validationError(.emailAddressRequired)
                }
                
                return try await environment.resetPassword(state.viewState.emailAddress)
            })
        }
    case .submissionResponse(.success):
        state.navigationPath.removeLast()
        return .none
    case let .submissionResponse(.failure(error)):
        state.viewState.emailAddress = error.friendlyMessage
        return .none
    }
}
