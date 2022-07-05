//
//  OrganisationsPicker.swift
//  Appeek
//
//  Created by Connor Black on 02/07/2022.
//

import SwiftUI

struct OrganisationsPicker: View {
    var organisations: [Organisation]
    @Binding var selectedOrganisation: Organisation?

    var body: some View {
        ZStack {
            Color.appeekBackgroundOffset
            HStack {
                Picker("Selected Company", selection: $selectedOrganisation) {
                    ForEach(organisations, id: \.self) { Text($0.name).tag($0) }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .pickerStyle(.menu)
                .tint(.appeekFont)
                
                Text(selectedOrganisation?.name ?? "No Organisations")
                    .foregroundColor(.appeekFont)
            }
        }
        .cornerRadius(5)
    }
}

struct OrganisationsPicker_Previews: PreviewProvider {
    static var previews: some View {
        let org = Organisation(id: UUID(), name: "Example Org", createdAt: "someDateTime")
        OrganisationsPicker(organisations: [org], selectedOrganisation: .constant(org))
    }
}
