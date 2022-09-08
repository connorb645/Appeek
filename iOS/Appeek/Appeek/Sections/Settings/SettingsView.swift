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
    
    let store: Store<SettingsStateCombined, SettingsAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            AppeekBackgroundView {
                ZStack {
                    Form {
                        Section("Actions") {
                            Button("Log Out", role: .destructive) {
                                viewStore.send(.logoutTapped)
                            }
                            Button("Close Settings", role: .cancel) {
                                viewStore.send(.dismissScreenTapped)
                            }
                        }
                    }
                    
                    if viewStore.viewState.isLoading {
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
        SettingsView(store: .init(initialState: SettingsStateCombined.preview,
                                  reducer: settingsReducer,
                                  environment: SettingsEnvironment.preview))
    }
}
