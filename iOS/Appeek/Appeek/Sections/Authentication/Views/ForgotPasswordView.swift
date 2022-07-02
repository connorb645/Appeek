//
//  ForgotPasswordView.swift
//  Appeek
//
//  Created by Connor Black on 30/06/2022.
//

import SwiftUI
import ConnorsComponents

struct ForgotPasswordView: View {
    enum FocusField: Hashable {
        case email
    }
    
    @EnvironmentObject var navigation: AppNavigation
    @EnvironmentObject var authentication: Authentication
    @StateObject var viewModel: ViewModel = ViewModel()
    @FocusState private var focusedField: FocusField?
    
    var body: some View {
        AppeekBackgroundView {
            ZStack {
                VStack {
                    ScrollView {
                        VStack {
                            header
                            
                            email
                            
                            Divider()
                            
                            if let errorMessage = viewModel.errorMessage {
                                error(errorMessage)
                            }
                        }
                    }
                                    
                    callToAction
                }
                
                if viewModel.isLoading {
                    CCProgressView(foregroundColor: .appeekPrimary,
                                   backgroundColor: .appeekBackgroundOffset)
                }
            }
        }
    }
    
    @ViewBuilder private var header: some View {
        Text("Let's get your account back")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.title)
            .fontWeight(.bold)
            .padding(.horizontal)
            .padding(.top)
    }
    
    @ViewBuilder private var email: some View {
        Group {
            CCEmailTextField(emailAddress: $viewModel.emailAddress,
                             placeholder: "Email Address",
                             foregroundColor: .appeekFont,
                             backgroundColor: .clear)
            .submitLabel(.next)
            .focused($focusedField, equals: .email)
            .onSubmit {
                focusedField = nil
                Task {
                    await viewModel.handlePasswordReset(with: authentication)
                }
            }
        }
        .padding(.horizontal)
    }
            
    @ViewBuilder private func error(_ message: String) -> some View {
        Text(message)
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(.pink)
            .font(.callout)
            .fontWeight(.regular)
            .padding(.horizontal)
    }
    
    @ViewBuilder private var callToAction: some View {
        VStack {
            CCPrimaryButton(title: "Reset password",
                            backgroundColor: .appeekPrimary) {
                Task {
                    await viewModel.handlePasswordReset(with: authentication)
                }
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .padding()
    }
}

extension ForgotPasswordView {
    struct Navigation: Hashable { }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
