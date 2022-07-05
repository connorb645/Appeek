//
//  SettingsView.swift
//  Appeek
//
//  Created by Connor Black on 30/06/2022.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var authentication: AuthenticationGateway
    @StateObject var viewModel: ViewModel = ViewModel()
    @Binding var isPresented: Bool
    
    var body: some View {
        AppeekBackgroundView {
            Form {
                Section("Sections One") {
                    Button("Log Out") {
                        Task {
                            await viewModel.logout(with: authentication)
                            if viewModel.errorMessage == nil {
                                self.isPresented = false
                                authentication.removeCurrentSession()
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
        SettingsView(isPresented: .constant(true))
    }
}
