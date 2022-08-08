//
//  AppAction.swift
//  Appeek
//
//  Created by Connor Black on 01/08/2022.
//

import SwiftUI

enum AppAction: Equatable {
    case onboarding(OnboardingAction)
    case signUp(SignUpAction)
    case login(LoginAction)
    case forgotPassword(ForgotPasswordAction)
    
    case onAppear
    case onboardingNavigationPathChanged(NavigationPath)
    case homeNavigationPathChanged(NavigationPath)
    case currentAuthSessionPossiblyReceived(Result<AuthSession?, AppeekError>)
}
