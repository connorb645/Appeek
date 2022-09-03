//
//  ForgotPasswordAction.swift
//  Appeek
//
//  Created by Connor Black on 01/08/2022.
//

import Foundation
import ComposableArchitecture

enum ForgotPasswordAction: Equatable {
    case onEmailChanged(String)
    case submitTapped
    case submissionResponse(TaskResult<Void>)
    
    static func == (lhs: ForgotPasswordAction, rhs: ForgotPasswordAction) -> Bool {
        switch (lhs, rhs) {
        case (let .onEmailChanged(l), let .onEmailChanged(r)):
            return l == r
        case (.submitTapped, .submitTapped):
            return true
        case (.submissionResponse, .submissionResponse):
            return true
        default:
            return false
        }
    }
}
