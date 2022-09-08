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
    let store: Store<HomeState, HomeAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationStack(path: viewStore.binding(get: \.navigationPath,
                                                    send: HomeAction.navigationPathChanged)) {
                AppeekBackgroundView {
                    ZStack {
                        VStack {
                            HStack {
                                AppeekPicker(items: viewStore.state.usersOrganisations,
                                             isLoading: viewStore.state.isLoading,
                                             selectedItem: viewStore.binding(get: \.selectedOrganisation,
                                                                             send: HomeAction.selectedOrganisationUpdated))
                                .frame(height: 50)
                                
                                if viewStore.state.selectedOrganisation != nil {
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
                    if viewStore.isLoading {
                        CCProgressView(foregroundColor: .appeekPrimary,
                                       backgroundColor: .appeekBackgroundOffset)
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
            }
            .sheet(unwrapping: viewStore.binding(get: \.route,
                                                 send: HomeAction.homeRouteChanged),
                   case: /HomeState.Route.settings) { _ in
                IfLetStore(self.store.scope(state: \.settingsStateCombined,
                                            action: HomeAction.settingsAction)) { store in
                    SettingsView(store: store)
                }

            }
            .sheet(unwrapping: viewStore.binding(get: \.route,
                                                 send: HomeAction.homeRouteChanged),
                   case: /HomeState.Route.organisationMembersList) { _ in
                IfLetStore(self.store.scope(state: \.organisationTeamMembersStateCombined,
                                            action: HomeAction.organisationMembersAction)) { store in
                    OrganisationMembersView(store: store)
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(store: .init(initialState: HomeState.preview,
                              reducer: homeReducer,
                              environment: HomeEnvironment.preview))
    }
}
