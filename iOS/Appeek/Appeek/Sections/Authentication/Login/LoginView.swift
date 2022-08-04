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

struct LoginStateWithRoute: Equatable {
    var loginState: LoginState
    var route: OnboardingRouteStack
    
    static let preview = Self(loginState: LoginState.preview,
                              route: .init())
}

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
    case goToSignUpTapped
}

// MARK: - Environment

struct LoginEnvironment {
    var login: (String, String) -> Effect<AuthSession, AppeekError>
    var persistAuthenticationState: (AuthSession) -> Void
    var validate: (ValidationRequirement) -> Bool
    
    var mainQueue: AnySchedulerOf<DispatchQueue>
    
    static let preview = Self(login: AuthenticateClient.live.login(email:password:),
                              persistAuthenticationState: AuthenticateClient.live.persistAuthenticationState(_:),
                              validate: ValidationClient.live.validate(_:),
                              mainQueue: .immediate)
}

// MARK: - Reducer

let loginReducer = Reducer<LoginStateWithRoute, LoginAction, LoginEnvironment> { state, action, environment in
    switch action {
    case let .emailAddressChanged(emailAddress):
        state.loginState.emailAddress = emailAddress
        return .none
    case let .passwordChanged(password):
        state.loginState.password = password
        return .none
    case .passwordSecurityToggled:
        state.loginState.securePassword.toggle()
        return .none
    case .loginTapped:
        guard environment.validate((state.loginState.emailAddress, ValidationField.email)) else {
            return Effect(value: LoginAction.loginResponse(
                .failure(.validationError(.emailAddressRequired))
            ))
        }
        return environment
            .login(state.loginState.emailAddress, state.loginState.password)
            .receive(on: environment.mainQueue)
            .catchToEffect(LoginAction.loginResponse)
    case let .loginResponse(.success(response)):
        environment.persistAuthenticationState(response)
        return .none
    case let .loginResponse(.failure(error)):
        state.loginState.errorMessage = error.friendlyMessage
        return .none
    case .goToSignUpTapped:
        state.route = OnboardingRouteStack.SignUpState
        return .none
    }
}

// MARK: - View

struct LoginView: View {
    
    enum FocusField: Hashable {
        case email, password
    }
    
    let store: Store<LoginStateWithRoute, LoginAction>
    
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
                                
                                if let errorMessage = viewStore.loginState.errorMessage {
                                    error(errorMessage)
                                }
                            }
                        }
                        callToAction(viewStore: viewStore)
                    }
                    
                    if viewStore.loginState.isLoading {
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
    
    private func email(viewStore: ViewStore<LoginStateWithRoute, LoginAction>) -> some View {
        Group {
            CCEmailTextField(emailAddress: viewStore.binding(get: \.loginState.emailAddress,
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
    
    private func password(viewStore: ViewStore<LoginStateWithRoute, LoginAction>) -> some View {
        Group {
            HStack {
                CCPasswordTextField(password: viewStore.binding(get: \.loginState.password,
                                                                send: LoginAction.passwordChanged),
                                    isSecure: viewStore.loginState.securePassword,
                                    placeholder: "Password",
                                    foregroundColor: .appeekFont,
                                    backgroundColor: .clear)
                .submitLabel(.next)
                .focused($focusedField, equals: .password)
                .onSubmit {
                    focusedField = nil
                    viewStore.send(.loginTapped)
                }
                
                CCIconButton(iconName: viewStore.loginState.securePassword ? "lock" : "lock.open") {
                    viewStore.send(.passwordSecurityToggled)
                }
            }
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder private var forgotPassword: some View {
        NavigationLink("Forgot Password", value: OnboardingRouteStack.State.forgotPassword)
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
    
    private func callToAction(viewStore: ViewStore<LoginStateWithRoute, LoginAction>) -> some View {
        VStack {
            CCPrimaryButton(title: "Login!",
                            backgroundColor: .appeekPrimary) {
                viewStore.send(.loginTapped)
            }
            
            CCSecondaryButton(title: "Don't have an account? Create one now!",
                              textColor: .appeekPrimary,
                              isUnderlined: false) {
                viewStore.send(.goToSignUpTapped)
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .padding()
    }
}

// MARK: - Preview

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(store: .init(initialState: LoginStateWithRoute.preview,
                               reducer: loginReducer,
                               environment: LoginEnvironment.preview))
    }
}

