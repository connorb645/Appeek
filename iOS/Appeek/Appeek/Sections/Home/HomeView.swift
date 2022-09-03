//
//  HomeView.swift
//  Appeek
//
//  Created by Connor Black on 30/06/2022.
//

import SwiftUI
import SwiftUINavigation
import ComposableArchitecture
import ConnorsComponents

struct HomeView: View {
    let store: Store<HomeStateWithRoute, HomeAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            AppeekBackgroundView {
                VStack {
                    HStack {
                        AppeekPicker(items: viewStore.state.state.usersOrganisations,
                                     isLoading: viewStore.state.state.isLoading,
                                     selectedItem: viewStore.binding(get: \.state.selectedOrganisation,
                                                                     send: HomeAction.selectedOrganisationUpdated))
                        .frame(height: 50)
                        
                        if viewStore.state.state.selectedOrganisation != nil {
                            Menu {
                                Button("Team members") {
                                    viewStore.send(.goToTeamMembersListTapped)
                                }
                            } label: {
                                Image(systemName: "ellipsis")
                                    .foregroundColor(Color.appeekFont)
                                    .frame(width: 45, height: 45)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onAppear {
                    viewStore.send(.onAppear)
                }
            }
            .navigationTitle("Home")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewStore.send(.goToSettingsTapped)
                    } label: {
                        Image(systemName: "gear")
                    }
                }
            }
            .sheet(unwrapping: viewStore.binding(get: \.state.homeRoute,
                                                 send: HomeAction.homeRouteChanged),
                   case: /HomeState.Route.settings) { _ in
                SettingsView(store: self.store.scope(state: \.settingsState,
                                                     action: HomeAction.settingsAction))

            }
            .sheet(unwrapping: viewStore.binding(get: \.state.homeRoute,
                                                 send: HomeAction.homeRouteChanged),
                   case: /HomeState.Route.organisationMembersList) { _ in
                OrganisationMembersView(store: self.store.scope(state: \.organisationMembersState,
                                                                action: HomeAction.organisationMembersAction))

            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(store: .init(initialState: HomeStateWithRoute.preview,
                              reducer: homeReducer,
                              environment: HomeEnvironment.preview))
    }
}
