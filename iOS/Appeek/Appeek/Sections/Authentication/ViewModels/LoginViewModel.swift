//
//  LoginViewModel.swift
//  Appeek
//
//  Created by Connor Black on 30/06/2022.
//

import Foundation

extension LoginView {
    class ViewModel: ObservableObject {
        @MainActor @Published var emailAddress: String = "connor.b645@gmail.com"
        @MainActor @Published var password: String = "Password"
        @MainActor @Published var passwordSecure = true
        
        @MainActor @Published var isLoading = false
        @MainActor @Published var errorMessage: String?
        
        @MainActor func handleLogin(with authentication: some AuthenticationProtocol) async {
            do {
                isLoading = true
                errorMessage = nil
                guard !emailAddress.isEmpty else {
                    throw ValidationError.emailAddressRequired
                }
                
                guard !password.isEmpty else {
                    throw ValidationError.passwordRequired
                }
                
                _ = try await authentication.login(email: emailAddress,
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
