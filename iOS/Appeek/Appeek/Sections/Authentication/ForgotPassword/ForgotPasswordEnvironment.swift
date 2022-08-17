//
//  ForgotPasswordEnvironment.swift
//  Appeek
//
//  Created by Connor Black on 01/08/2022.
//

import Foundation
import ComposableArchitecture

struct ForgotPasswordEnvironment {
    var resetPassword: (String) -> Effect<Bool, AppeekError>
    var validate: (ValidationRequirement) -> Bool
    
    var mainQueue: AnySchedulerOf<DispatchQueue>
    
    static let preview = Self(resetPassword: AuthenticateClient.preview.resetPassword(email:),
                              validate: ValidationClient.preview.validate(_:),
                              mainQueue: .immediate)
}
