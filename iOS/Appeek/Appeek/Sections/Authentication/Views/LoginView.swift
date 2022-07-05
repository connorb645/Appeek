//
//  LoginView.swift
//  Appeek
//
//  Created by Connor Black on 30/06/2022.
//

import SwiftUI
import ConnorsComponents

struct LoginView: View {
    enum FocusField: Hashable {
        case email, password
    }
    
    @EnvironmentObject var navigation: AppNavigation
    @EnvironmentObject var authentication: AuthenticationGateway
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
                            
                            forgotPassword
                            
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
            .navigationDestination(for: ForgotPasswordView.Navigation.self) { _ in
                ForgotPasswordView()
            }
        }
    }
    
    @ViewBuilder private var header: some View {
        Text("✌️ 😁 👋")
            .font(.largeTitle)
            .padding(.top)
        
        Text("Welcome back! Login")
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
            HStack {
                CCPasswordTextField(password: $viewModel.password,
                                    isSecure: viewModel.passwordSecure,
                                    placeholder: "Password",
                                    foregroundColor: .appeekFont,
                                    backgroundColor: .clear)
                .submitLabel(.next)
                .focused($focusedField, equals: .password)
                .onSubmit {
                    focusedField = nil
                    Task {
                        await viewModel.handleLogin(with: authentication)
                        navigation.mainNavigation = .init()
                    }
                }
                
                CCIconButton(iconName: viewModel.passwordSecure ? "lock" : "lock.open") {
                    viewModel.passwordSecure.toggle()
                }
            }
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder private var forgotPassword: some View {
        NavigationLink("Forgot Password", value: ForgotPasswordView.Navigation())
            .frame(maxWidth: .infinity, alignment: .trailing)
            .tint(Color.appeekFont)
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
            CCPrimaryButton(title: "Login!",
                            backgroundColor: .appeekPrimary) {
                Task {
                    await viewModel.handleLogin(with: authentication)
                    navigation.mainNavigation = .init()
                }
            }
            
            CCSecondaryButton(title: "Don't have an account? Create one now!",
                              textColor: .appeekPrimary,
                              isUnderlined: false) {
                navigation.mainNavigation.removeLast()
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .padding()
    }
}

extension LoginView {
    struct Navigation: Hashable { }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

