//
//  OrganisationsListView.swift
//  Appeek
//
//  Created by Connor Black on 02/10/2022.
//

import SwiftUI
import ComposableArchitecture
import ConnorsComponents

struct OrganisationsListView: View {
    let store: Store<OrganisationsListState, OrganisationsListAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            AppeekBackgroundView {
                NavigationStack(path: viewStore.binding(
                    get: \.navigationPath,
                    send: OrganisationsListAction.navigationPathChanged)
                ) {
                    ZStack {
                        List {
                            Section("Actions") {
                                Button("Join Team") {
                                    viewStore.send(.joinTeamTapped)
                                }
                            }
                            Section("Your Teams") {
                                ForEach(viewStore.usersOrganisations) { team in
                                    Button(team.name) {
                                        viewStore.send(.teamSelected(team))
                                    }
                                    .tint(.appeekFont)
                                }
                            }
                        }
                        
                        if viewStore.isLoading {
                            CCProgressView(foregroundColor: .appeekPrimary,
                                           backgroundColor: .appeekBackgroundOffset)
                        }
                    }
                    .onAppear {
                        viewStore.send(.onAppear)
                    }
                    .navigationDestination(for: OrganisationsListRoute.self) { route in
                        switch route {
                        case .home:
                            IfLetStore(
                                self.store.scope(
                                    state: \.homeStateCombined,
                                    action: OrganisationsListAction.homeAction)
                            ) { store in
                                HomeView(store: store)
                            }
                        }
                    }
                }
            }
        }
    }
}
