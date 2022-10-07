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
                NavigationStack(path: viewStore.binding(
                    get: \.viewState.navigationPath,
                    send: OrganisationMembersAction.navigationPathChanged)
                ) {
                    ZStack {
                        List {
                            Section("Team Identifier") {
                                teamIdentifier(viewStore)
                            }
                            
                            if viewStore.viewState.isCurrentUserAdmin {
                                Section("Admin Actions") {
                                    Button("Invite a team member") {
                                        viewStore.send(.inviteTeamMemberTapped)
                                    }
                                }
                            }
                            
                            Section("Team Admins") {
                                ForEach(viewStore.viewState.admins) { member in
                                    memberItem(member: member, viewStore)
                                }
                            }
                            
                            Section("Team Members") {
                                ForEach(viewStore.viewState.nonAdmins) { member in
                                    memberItem(member: member, viewStore)
                                }
                            }
                        }
                        
                        if viewStore.viewState.isLoading {
                            CCProgressView(foregroundColor: .appeekPrimary,
                                           backgroundColor: .appeekBackgroundOffset)
                        }
                    }
                    .navigationBarItems(trailing: closeButton(viewStore))
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
    
    @ViewBuilder
    private func memberItem(member: UserPublicDetails,
        _ viewStore: ViewStore<OrganisationMembersStateCombined, OrganisationMembersAction>
    ) -> some View {
        if let currentUserId = viewStore.viewState.currentUserId,
           member.userId == currentUserId {
            Text("You")
        } else {
            Text("\(member.firstName) \(member.lastName)")
        }
    }
    
    @ViewBuilder
    private func closeButton(
        _ viewStore: ViewStore<OrganisationMembersStateCombined, OrganisationMembersAction>
    ) -> some View {
        Button {
            viewStore.send(.dismissTapped)
        } label: {
            Image(systemName: "xmark")
        }
        .tint(.appeekFont)
    }
    
    @ViewBuilder
    private func teamIdentifier(
        _ viewStore: ViewStore<OrganisationMembersStateCombined, OrganisationMembersAction>
    ) -> some View {
        Button {
            print("Copy the uuid")
        } label: {
            HStack {
                Group {
                    Text("\(String(viewStore.selectedOrganisaion.id.uuidString.prefix(8)))")
                        .font(.subheadline) +
                    Text(" - ")
                        .font(.subheadline) +
                    Text("\(viewStore.viewState.dots(4))")
                        .fontWeight(.black) +
                    Text(" - ")
                        .font(.subheadline) +
                    Text("\(viewStore.viewState.dots(4))")
                        .fontWeight(.black) +
                    Text(" - ")
                        .font(.subheadline) +
                    Text("\(viewStore.viewState.dots(4))")
                        .fontWeight(.black) +
                    Text(" - ")
                        .font(.subheadline) +
                    Text("\(viewStore.viewState.dots(12))")
                        .fontWeight(.black)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: "doc.on.doc")
            }
        }
        .tint(.appeekFont)
    }
}

struct OrganisationMembersView_Previews: PreviewProvider {
    static var previews: some View {
        OrganisationMembersView(store: .init(initialState: .preview,
                                             reducer: organisationMembersReducer,
                                             environment: OrganisationMembersEnvironment.preview))
    }
}
