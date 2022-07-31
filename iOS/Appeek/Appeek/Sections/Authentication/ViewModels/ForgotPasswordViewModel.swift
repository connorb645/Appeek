//
//  ForgotPasswordViewModel.swift
//  Appeek
//
//  Created by Connor Black on 30/06/2022.
//

import Foundation

extension ForgotPasswordView {
    class ViewModel: ObservableObject {
        
        @MainActor @Published var emailAddress: String = "connor.b645@gmail.com"
        @MainActor @Published var isLoading: Bool = false
        @MainActor @Published var errorMessage: String?
        
        @MainActor func handlePasswordReset(with authentication: AuthenticationGateway) async {
            do {
                isLoading = true
                errorMessage = nil
                guard !emailAddress.isEmpty else {
                    throw AppeekError.validationError(.emailAddressRequired)
                }
                
                _ = try await authentication.resetPassword(email: emailAddress)
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
