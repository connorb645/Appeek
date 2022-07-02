//
//  HomeView.swift
//  Appeek
//
//  Created by Connor Black on 30/06/2022.
//

import SwiftUI

struct HomeView: View {
    @State var isShowingSettings: Bool = false
    @EnvironmentObject var authentication: Authentication
    
    var body: some View {
        NavigationStack {
            AppeekBackgroundView {
                VStack {
                    OrganisationsPicker()
                        .frame(height: 50)
                        .padding(.horizontal)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onAppear {
                    #if DEBUG
                    print("ACCESS TOKEN: \(authentication.currentSession?.accessToken ?? "")")
                    Task {
                        do {
                            guard let userId = authentication.currentSession?.userId,
                                  let accessToken = authentication.currentSession?.accessToken else {
                                return
                            }
                            let result = try await SupabaseAPI().organisations(for: userId,
                                                                               bearerToken: accessToken)
                        } catch let error {
                            print(error)
                        }
                        
                    }
                    #endif
                }
            }
            .navigationTitle("Home")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingSettings.toggle()
                    } label: {
                        Image(systemName: "gear")
                    }
                }
            }
            .sheet(isPresented: $isShowingSettings) {
                SettingsView()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
