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
    @StateObject var viewModel: ViewModel = ViewModel()
    @FocusState private var focusedField: FocusField?
    
    var body: some View {
        AppeekBackgroundView {
            VStack {
                ScrollView {
                    VStack {
                        Text("✌️ 😁 👋")
                            .font(.largeTitle)
                            .padding(.top)
                        
                        Text("Create your account")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                            .padding(.top)
                        
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
                        
                        Divider()
                        
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
                                        await viewModel.handleAccountCreation()
                                    }
                                }
                                
                                CCIconButton(iconName: viewModel.passwordSecure ? "lock" : "lock.open") {
                                    viewModel.passwordSecure.toggle()
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        Divider()
                        
                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.pink)
                                .font(.callout)
                                .fontWeight(.regular)
                                .padding(.horizontal)
                        }
                    }
                }
                                
                VStack {
                    CCPrimaryButton(title: "Create account!",
                                    backgroundColor: .appeekPrimary) {
                        Task {
                            await viewModel.handleAccountCreation()
                        }
                    }
                    
                    NavigationLink("Already have an account? Log in!",
                                   value: "Login")
                        .foregroundColor(.appeekPrimary)
                }
                .ignoresSafeArea(.keyboard, edges: .bottom)
                .padding()
            }
            .navigationDestination(for: String.self) { _ in
                Text("Login")
            }
        }
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
