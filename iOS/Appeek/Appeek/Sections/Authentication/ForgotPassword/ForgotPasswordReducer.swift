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
    ForgotPasswordStateWithRoute,
    ForgotPasswordAction,
    ForgotPasswordEnvironment
>

let forgotPasswordReducer = ForgotPasswordReducer { state, action, environment in
    switch action {
    case let .onEmailChanged(value):
        state.forgotPasswordState.emailAddress = value
        return .none
    case .submitTapped:
        return .task { [state = state.forgotPasswordState] in
            await .submissionResponse(TaskResult {
                guard environment.validate(
                    (state.emailAddress, ValidationField.email)
                ) else {
                    throw AppeekError.validationError(.emailAddressRequired)
                }
                
                return try await environment.resetPassword(state.emailAddress)
            })
        }
    case .submissionResponse(.success):
        state.route = (/AppRoute.onboarding).embed(OnboardingRouteStack.LoginState)
        return .none
    case let .submissionResponse(.failure(error)):
        state.forgotPasswordState.emailAddress = error.friendlyMessage
        return .none
    }
}
