//
//  ForgotPasswordAction.swift
//  Appeek
//
//  Created by Connor Black on 01/08/2022.
//

import Foundation

enum ForgotPasswordAction: Equatable {
    case onEmailChanged(String)
    case submitTapped
    case submissionResponse(Result<Bool, AppeekError>)
}
