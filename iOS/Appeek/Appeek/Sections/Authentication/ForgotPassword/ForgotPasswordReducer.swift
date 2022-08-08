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
        guard environment.validate(
            (state.forgotPasswordState.emailAddress, ValidationField.email)
        ) else {
            return Effect(value: ForgotPasswordAction.submissionResponse(
                .failure(.validationError(.emailAddressRequired))
            ))
        }
        
        return environment
            .resetPassword(state.forgotPasswordState.emailAddress)
            .receive(on: environment.mainQueue)
            .catchToEffect(ForgotPasswordAction.submissionResponse)
    case .submissionResponse(.success):
        state.route = (/AppRoute.onboarding).embed(OnboardingRouteStack.LoginState)
        return .none
    case let .submissionResponse(.failure(error)):
        state.forgotPasswordState.emailAddress = error.friendlyMessage
        return .none
    }
}
