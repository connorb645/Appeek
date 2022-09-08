//
//  OrganisationMembersView.swift
//  Appeek
//
//  Created by Connor Black on 21/08/2022.
//

import SwiftUI
import ComposableArchitecture
import ConnorsComponents

struct OrganisationMembersView: View {
    let store: Store<OrganisationMembersStateCombined, OrganisationMembersAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            AppeekBackgroundView {
                ZStack {
                    List {
                        ForEach(viewStore.viewState.teamMembers) { member in
                            Text("\(member.firstName) \(member.lastName)")
                        }
                    }
                    
                    if viewStore.viewState.isLoading {
                        CCProgressView(foregroundColor: .appeekPrimary,
                                       backgroundColor: .appeekBackgroundOffset)
                    }
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}

struct OrganisationMembersView_Previews: PreviewProvider {
    static var previews: some View {
        OrganisationMembersView(store: .init(initialState: .preview,
                                             reducer: organisationMembersReducer,
                                             environment: OrganisationMembersEnvironment.preview))
    }
}
