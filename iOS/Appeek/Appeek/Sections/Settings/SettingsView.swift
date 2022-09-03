//
//  SettingsView.swift
//  Appeek
//
//  Created by Connor Black on 30/06/2022.
//

import SwiftUI
import ConnorsComponents
import ComposableArchitecture

struct SettingsView: View {
    
    let store: Store<SettingsStateWithRoute, SettingsAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            AppeekBackgroundView {
                ZStack {
                    Form {
                        Section("Sections One") {
                            Button("Log Out") {
                                viewStore.send(.logoutTapped)
                            }
                        }
                    }
                    
                    if viewStore.state.state.isLoading {
                        CCProgressView(foregroundColor: .appeekPrimary,
                                       backgroundColor: .appeekBackgroundOffset)
                    }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(store: .init(initialState: SettingsStateWithRoute.preview,
                                  reducer: settingsReducer,
                                  environment: SettingsEnvironment.preview))
    }
}
