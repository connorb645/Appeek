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
    let store: Store<HomeStateCombined, HomeAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            AppeekBackgroundView {
                ZStack {
                    VStack {
                        joinTeamButton(viewStore)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onAppear {
                        viewStore.send(.onAppear)
                    }
                }
                if viewStore.viewState.isLoading {
                    CCProgressView(foregroundColor: .appeekPrimary,
                                   backgroundColor: .appeekBackgroundOffset)
                }
            }
            .navigationTitle(viewStore.selectedOrganisation.name)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewStore.send(.goToSettingsTapped)
                    } label: {
                        Image(systemName: "gear")
                    }
                }
            }
            .sheet(unwrapping: viewStore.binding(get: \.viewState.route,
                                                 send: HomeAction.homeRouteChanged),
                   case: /HomeState.Route.settings) { _ in
                IfLetStore(self.store.scope(state: \.settingsStateCombined,
                                            action: HomeAction.settingsAction)) { store in
                    SettingsView(store: store)
                }
            }
            .sheet(unwrapping: viewStore.binding(get: \.viewState.route,
                                                 send: HomeAction.homeRouteChanged),
                   case: /HomeState.Route.organisationMembersList) { _ in
                IfLetStore(self.store.scope(state: \.organisationTeamMembersStateCombined,
                                            action: HomeAction.organisationMembersAction)) { store in
                    OrganisationMembersView(store: store)
                }
            }
        }
    }
    
    @ViewBuilder
    private func joinTeamButton(_ viewStore: ViewStore<HomeStateCombined, HomeAction>) -> some View {
        CCPrimaryButton(title: "Join Team",
                        textColor: .appeekFont,
                        backgroundColor: .appeekBackgroundOffset,
                        height: 45) {
            print("Navigate to join team")
        }
        .padding(.horizontal)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(store: .init(initialState: HomeStateCombined.preview,
                              reducer: homeReducer,
                              environment: HomeEnvironment.preview))
    }
}
