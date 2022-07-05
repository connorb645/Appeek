//
//  HomeViewModel.swift
//  Appeek
//
//  Created by Connor Black on 02/07/2022.
//

import Foundation

extension HomeView {
    class ViewModel: ObservableObject {
        let apiGateway: APIGateway
        @MainActor @Published var isLoading = false
        @MainActor @Published var errorMessage: String?
        @MainActor @Published var usersOrganisations: [Organisation] = []
        @MainActor @Published var selectedOrganisation: Organisation?
        
        init(apiGateway: APIGateway = APIGateway()) {
            self.apiGateway = apiGateway
        }
        
        @MainActor func fetchUsersOrganisations(using authentication: AuthenticationGateway) async {
            isLoading = true
            do {
                guard let currentUserId = authentication.currentSession?.userId else {
                    self.errorMessage = NetworkError.noSession.friendlyMessage
                    return
                }
                self.usersOrganisations = try await self.apiGateway.organisations(for: currentUserId,
                                                                                  authenticationGateway: authentication)
                self.selectedOrganisation = usersOrganisations.first
            } catch let error as AppeekError {
                errorMessage = error.friendlyMessage
            } catch let error {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}
