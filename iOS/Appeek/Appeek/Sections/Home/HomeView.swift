//
//  HomeView.swift
//  Appeek
//
//  Created by Connor Black on 30/06/2022.
//

import SwiftUI
import SwiftUINavigation
import ComposableArchitecture

struct HomeView: View {
    let store: Store<HomeStateWithRoute, HomeAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            AppeekBackgroundView {
                VStack {
                    AppeekPicker(items: viewStore.state.state.usersOrganisations,
                                 isLoading: viewStore.state.state.isLoading,
                                 selectedItem: viewStore.binding(get: \.state.selectedOrganisation,
                                                                 send: HomeAction.selectedOrganisationUpdated))
                    .frame(height: 50)
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
                        viewStore.send(.settingsTapped)
                    } label: {
                        Image(systemName: "gear")
                    }
                }
            }
            .sheet(unwrapping: viewStore.binding(get: \.state.homeRoute,
                                                 send: HomeAction.homeRouteChanged),
                   case: /HomeState.Route.settings) { $settings in
                       Text("Settings")
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
