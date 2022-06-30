//
//  SettingsViewModel.swift
//  Appeek
//
//  Created by Connor Black on 30/06/2022.
//

import SwiftUI

extension SettingsView {
    class ViewModel: ObservableObject {
        @MainActor @Published var isLoading: Bool = false
        @MainActor @Published var errorMessage: String?
        
        @MainActor func logout(with authentication: some Authentication) async {
            do {
                self.isLoading = true
                try await authentication.logout()
            } catch let error as AppeekError {
                self.isLoading = false
                self.errorMessage = error.friendlyMessage
            } catch let error {
                self.isLoading = false
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
