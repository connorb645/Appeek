//
//  JoinOrganisationView.swift
//  Appeek
//
//  Created by Connor Black on 07/10/2022.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import ConnorsComponents

struct JoinOrganisationView: View {
    let store: Store<JoinOrganisationStateCombined, JoinOrganisationAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            AppeekBackgroundView {
                ZStack {
                    Form {
                        Section {
                            TextField(
                                "Enter the team Identifier",
                                text: viewStore.binding(
                                    get: \.viewState.teamIdentifier,
                                    send: JoinOrganisationAction.teamIdentifierChanged
                                )
                            )
                            Button("Join Team") {
                                viewStore.send(.joinTeamTapped)
                            }
                        }
                    }
                    
                    if viewStore.viewState.isLoading {
                        CCProgressView(
                            foregroundColor: .appeekPrimary,
                            backgroundColor: .appeekBackgroundOffset
                        )
                    }
                }
                .navigationTitle("Join a team")
                .onAppear {
                    viewStore.send(.onAppear)
                }
            }
        }
    }
}
