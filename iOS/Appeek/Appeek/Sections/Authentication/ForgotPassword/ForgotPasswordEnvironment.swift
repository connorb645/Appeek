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
    
    static let preview = Self(resetPassword: AuthenticateClient.live.resetPassword(email:),
                              validate: ValidationClient.live.validate(_:),
                              mainQueue: .immediate)
}
