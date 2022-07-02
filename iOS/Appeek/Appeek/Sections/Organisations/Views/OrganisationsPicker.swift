//
//  OrganisationsPicker.swift
//  Appeek
//
//  Created by Connor Black on 02/07/2022.
//

import SwiftUI

struct OrganisationsPicker: View {
    let companies: [String] = ["Company One", "Company Two", "Company Three"]
    @State var selectedCompany: String = "Company One"
    
    var body: some View {
        ZStack {
            Color.appeekBackgroundOffset
            Picker("Selected Company", selection: $selectedCompany) {
                ForEach(companies, id: \.self) { Text($0) }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .pickerStyle(.menu)
            .tint(.appeekFont)
        }
        .cornerRadius(5)
    }
}

struct OrganisationsPicker_Previews: PreviewProvider {
    static var previews: some View {
        OrganisationsPicker()
    }
}
