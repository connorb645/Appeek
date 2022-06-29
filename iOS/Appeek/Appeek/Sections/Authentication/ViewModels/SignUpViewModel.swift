//
//  SignUpViewModel.swift
//  Appeek
//
//  Created by Connor Black on 28/06/2022.
//

import Foundation

extension SignUpView {
    class ViewModel: ObservableObject {
        let authentication: any AuthenticationProtocol
        
        @Published var emailAddress: String = "connor.b645@gmail.com"
        @Published var password: String = "Password"
        @Published var confirmPassword: String = "Password"
        @Published var passwordSecure = true
        
        @MainActor @Published var errorMessage: String?
        
        init(authentication: any AuthenticationProtocol = Authentication()) {
            self.authentication = authentication
        }
        
        @MainActor func handleAccountCreation() async {
            do {
                guard !emailAddress.isEmpty else {
                    throw ValidationError.emailAddressRequired
                }
                
                guard !password.isEmpty else {
                    throw ValidationError.passwordRequired
                }
                
                guard !confirmPassword.isEmpty else {
                    throw ValidationError.passwordConfirmationRequired
                }
                
                guard password == confirmPassword else {
                    throw ValidationError.passwordsDontMatch
                }
                _ = try await authentication.signUp(email: emailAddress,
                                                    password: password)
            } catch let error as AppeekError {
                errorMessage = error.friendlyMessage
            } catch let error {
                errorMessage = error.localizedDescription
            }
            
        }
    }
}
