//
//  HomeView.swift
//  Appeek
//
//  Created by Connor Black on 30/06/2022.
//

import SwiftUI

struct HomeView: View {
    @State var isShowingSettings: Bool = false
    @EnvironmentObject var authentication: AuthenticationGateway
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            AppeekBackgroundView {
                VStack {
                    AppeekPicker(items: viewModel.usersOrganisations,
                                 isLoading: viewModel.isLoading,
                                 selectedItem: $viewModel.selectedOrganisation)
                    .frame(height: 50)
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onAppear {
                    Task {
                        await self.viewModel.fetchUsersOrganisations(using: self.authentication)
                    }
                }
            }
            .navigationTitle("Home")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingSettings = true
                    } label: {
                        Image(systemName: "gear")
                    }
                }
            }
            .sheet(isPresented: $isShowingSettings) {
                SettingsView(isPresented: $isShowingSettings)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
