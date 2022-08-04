//
//  ForgotPasswordState.swift
//  Appeek
//
//  Created by Connor Black on 01/08/2022.
//

import Foundation

struct ForgotPasswordStateWithRoute: Equatable {
    var forgotPasswordState: ForgotPasswordState
    var route: OnboardingRouteStack
    
    static let preview = Self(forgotPasswordState: ForgotPasswordState.preview,
                              route: .init())
}

struct ForgotPasswordState: Equatable {
    var errorMessage: String? = nil
    var isLoading: Bool = false
    var emailAddress: String = ""
    
    static let preview = Self()
}
