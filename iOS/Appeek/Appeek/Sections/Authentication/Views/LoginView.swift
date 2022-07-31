//
//  LoginView.swift
//  Appeek
//
//  Created by Connor Black on 30/06/2022.
//

import SwiftUI
import ConnorsComponents
import ComposableArchitecture

// MARK: - State

struct LoginState: Equatable {
    var emailAddress: String = ""
    var password: String = ""
    var errorMessage: String? = nil
    var isLoading: Bool = false
    var securePassword: Bool = true
    
    static let preview = Self()
}

// MARK: - Action

enum LoginAction: Equatable {
    case emailAddressChanged(String)
    case passwordChanged(String)
    case passwordSecurityToggled
    case loginTapped
    case loginResponse(Result<AuthSession, AppeekError>)
}

// MARK: - Environment

struct LoginEnvironment {
    // TODO: - Dont think we need to full authenticateClient
    var authenticateClient: AuthenticateClientProtocol
    var validationClient: ValidationClientProtocol
    
    var mainQueue: AnySchedulerOf<DispatchQueue>
    
    static let preview = Self(authenticateClient: AuthenticateClient.live,
                              validationClient: ValidationClient.live,
                              mainQueue: .immediate)
}

// MARK: - Reducer

let loginReducer = Reducer<LoginState, LoginAction, LoginEnvironment> { state, action, environment in
    switch action {
    case let .emailAddressChanged(emailAddress):
        state.emailAddress = emailAddress
        return .none
    case let .passwordChanged(password):
        state.password = password
        return .none
    case .passwordSecurityToggled:
        state.securePassword.toggle()
    case .loginTapped:
        // TODO: - Validate email before making call.
        return environment
            .authenticateClient
            .login(email: state.emailAddress, password: state.password)
            .receive(on: environment.mainQueue)
            .catchToEffect(LoginAction.loginResponse)
    case let .loginResponse(.success(response)):
        environment.authenticateClient.persistAuthenticationState(response)
        return .none
    case let .loginResponse(.failure(error)):
        state.errorMessage = error.friendlyMessage
        return .none
    }
}

// MARK: - View

struct LoginView: View {
    
    enum FocusField: Hashable {
        case email, password
    }
    
    let store: Store<LoginState, LoginAction>
    
    @FocusState private var focusedField: FocusField?
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            AppeekBackgroundView {
                ZStack {
                    VStack {
                        ScrollView {
                            VStack {
                                header
                                
                                email(viewStore: viewStore)
                                
                                Divider()
                                
                                password(viewStore: viewStore)
                                
                                forgotPassword
                                
                                Divider()
                                
                                if let errorMessage = viewStore.errorMessage {
                                    error(errorMessage)
                                }
                            }
                        }
                        callToAction(viewStore: viewStore)
                    }
                    
                    if viewStore.isLoading {
                        CCProgressView(foregroundColor: .appeekPrimary,
                                       backgroundColor: .appeekBackgroundOffset)
                    }
                }
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
    
    private func email(viewStore: ViewStore<LoginState, LoginAction>) -> some View {
        Group {
            CCEmailTextField(emailAddress: viewStore.binding(get: \.emailAddress,
                                                             send: LoginAction.emailAddressChanged),
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
    
    private func password(viewStore: ViewStore<LoginState, LoginAction>) -> some View {
        Group {
            HStack {
                CCPasswordTextField(password: viewStore.binding(get: \.password,
                                                                send: LoginAction.passwordChanged),
                                    isSecure: viewStore.securePassword,
                                    placeholder: "Password",
                                    foregroundColor: .appeekFont,
                                    backgroundColor: .clear)
                .submitLabel(.next)
                .focused($focusedField, equals: .password)
                .onSubmit {
                    focusedField = nil
                    viewStore.send(.loginTapped)
                }
                
                CCIconButton(iconName: viewStore.securePassword ? "lock" : "lock.open") {
                    viewStore.send(.passwordSecurityToggled)
                }
            }
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder private var forgotPassword: some View {
        // TODO: - Make this work with new navigation style...
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
    
    private func callToAction(viewStore: ViewStore<LoginState, LoginAction>) -> some View {
        VStack {
            CCPrimaryButton(title: "Login!",
                            backgroundColor: .appeekPrimary) {
                viewStore.send(.loginTapped)
            }
            
            CCSecondaryButton(title: "Don't have an account? Create one now!",
                              textColor: .appeekPrimary,
                              isUnderlined: false) {
                // TODO: - Need to pop off a screen...
//                navigation.mainNavigation.removeLast()
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .padding()
    }
}

// MARK: - Preview

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        // TODO: - Get preview working
        LoginView()
    }
}

