//
//  SignUpView.swift
//  Appeek
//
//  Created by Connor Black on 28/06/2022.
//

import SwiftUI
import ConnorsComponents

struct SignUpView: View {
    enum FocusField: Hashable {
        case email, password, confirmPassword
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
                            
                            password
                            
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
            .navigationDestination(for: String.self) { _ in
                Text("Login")
            }
        }
    }
    
    @ViewBuilder private var header: some View {
        Text("✌️ 😁 👋")
            .font(.largeTitle)
            .padding(.top)
        
        Text("Create your account")
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
                focusedField = .password
            }
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder private var password: some View {
        Group {
            CCPasswordTextField(password: $viewModel.password,
                                isSecure: viewModel.passwordSecure,
                                placeholder: "Password",
                                foregroundColor: .appeekFont,
                                backgroundColor: .clear)
            .submitLabel(.next)
            .focused($focusedField, equals: .password)
            .onSubmit {
                focusedField = .confirmPassword
            }
            
            HStack {
                CCPasswordTextField(password: $viewModel.confirmPassword,
                                    isSecure: viewModel.passwordSecure,
                                    placeholder: "Confirm Password",
                                    foregroundColor: .appeekFont,
                                    backgroundColor: .clear)
                .submitLabel(.done)
                .focused($focusedField, equals: .confirmPassword)
                .onSubmit {
                    focusedField = nil
                    Task {
                        await viewModel.handleAccountCreation(with: authentication)
                    }
                }
                
                CCIconButton(iconName: viewModel.passwordSecure ? "lock" : "lock.open") {
                    viewModel.passwordSecure.toggle()
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
            CCPrimaryButton(title: "Create account!",
                            backgroundColor: .appeekPrimary) {
                Task {
                    await viewModel.handleAccountCreation(with: authentication)
                }
            }
            
            NavigationLink("Already have an account? Log in!",
                           value: "Login")
                .foregroundColor(.appeekPrimary)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .padding()
    }
}

extension SignUpView {
    struct Navigation: Hashable { }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
