//
//  SignUpViewModel.swift
//  Appeek
//
//  Created by Connor Black on 28/06/2022.
//

import Foundation

extension SignUpView {
    class ViewModel: ObservableObject {
        @MainActor @Published var emailAddress: String = "connor.b645@gmail.com"
        @MainActor @Published var password: String = "Password"
        @MainActor @Published var confirmPassword: String = "Password"
        @MainActor @Published var passwordSecure = true
        
        @MainActor @Published var isLoading = false
        @MainActor @Published var errorMessage: String?
        
        @MainActor func handleAccountCreation(with authentication: AuthenticationGateway) async {
            do {
                isLoading = true
                errorMessage = nil
                guard !emailAddress.isEmpty else {
                    throw AppeekError.validationError(.emailAddressRequired)
                }
                
                guard !password.isEmpty else {
                    throw AppeekError.validationError(.passwordRequired)
                }
                
                guard !confirmPassword.isEmpty else {
                    throw AppeekError.validationError(.passwordConfirmationRequired)
                }
                
                guard password == confirmPassword else {
                    throw AppeekError.validationError(.passwordsDontMatch)
                }
                _ = try await authentication.signUp(email: emailAddress,
                                                    password: password)
                isLoading = false
            } catch let error as AppeekError {
                errorMessage = error.friendlyMessage
                isLoading = false
            } catch let error {
                errorMessage = error.localizedDescription
                isLoading = false
            }
            
        }
    }
}
