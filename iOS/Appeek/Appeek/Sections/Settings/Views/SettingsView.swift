//
//  SettingsView.swift
//  Appeek
//
//  Created by Connor Black on 30/06/2022.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var authentication: Authentication
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: ViewModel = ViewModel()
    
    var body: some View {
        AppeekBackgroundView {
            Form {
                Section("Sections One") {
                    Button("Log Out") {
                        Task {
                            await viewModel.logout(with: authentication)
                            if viewModel.errorMessage == nil {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }
                }
            }
        }
    }
}

extension SettingsView {
    struct Navigation: Hashable { }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
