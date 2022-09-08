//
//  OrganisationMembersView.swift
//  Appeek
//
//  Created by Connor Black on 21/08/2022.
//

import SwiftUI
import ComposableArchitecture

struct OrganisationMembersView: View {
    let store: Store<OrganisationMembersStateCombined, OrganisationMembersAction>
    
    var body: some View {
        Text("Hello, World!")
    }
}

struct OrganisationMembersView_Previews: PreviewProvider {
    static var previews: some View {
        OrganisationMembersView(store: .init(initialState: .preview,
                                             reducer: organisationMembersReducer,
                                             environment: OrganisationMembersEnvironment.preview))
    }
}
