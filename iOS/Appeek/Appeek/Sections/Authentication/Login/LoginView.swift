//
//  LoginView.swift
//  Appeek
//
//  Created by Connor Black on 30/06/2022.
//

import SwiftUI
import ConnorsComponents
import ComposableArchitecture

enum LoginRoute {
    case forgotPassword
}

// MARK: - State

struct LoginStateCombined: Equatable {
    var viewState: LoginState
    var navigationPath: NavigationPath
    
    var forgotPasswordStateCombined: ForgotPasswordStateCombined {
        get {
            .init(viewState: viewState.forgotPasswordState,
                  navigationPath: navigationPath)
        }
        set {
            self.viewState.forgotPasswordState = newValue.viewState
            self.navigationPath = newValue.navigationPath
        }
    }
    
    static let preview = Self(viewState: LoginState.preview,
                              navigationPath: .init())
}

struct LoginState: Equatable {
    
    var forgotPasswordState: ForgotPasswordState {
        get {
            self._forgotPasswordState ?? .init()
        }
        set {
            self._forgotPasswordState = newValue
        }
    }
    private var _forgotPasswordState: ForgotPasswordState?
    
    var emailAddress: String
    var password: String
    var errorMessage: String?
    var isLoading: Bool
    var securePassword: Bool
    
    init(emailAddress: String = "",
         password: String = "",
         errorMessage: String? = nil,
         isLoading: Bool = false,
         securePassword: Bool = true) {
        self.emailAddress = emailAddress
        self.password = password
        self.errorMessage = errorMessage
        self.isLoading = isLoading
        self.securePassword = securePassword
    }
    
    static let preview = Self()
}

// MARK: - Action

enum LoginAction: Equatable {
    case forgotPasswordAction(ForgotPasswordAction)
    
    case onAppear
    case emailAddressChanged(String)
    case passwordChanged(String)
    case passwordSecurityToggled
    case loginTapped
    case loginResponse(TaskResult<AuthSession>)
    case goToSignUpTapped
    case loggedIn
}

// MARK: - Environment

struct LoginEnvironment {
    var loginClient: LoginClient
    var validate: (ValidationRequirement) -> Bool
    var resetPassword: (String) async throws -> Void
        
    static let preview = Self(loginClient: LoginClient.preview,
                              validate: ValidationClient.preview.validate(_:),
                              resetPassword: { _ in })
}

// MARK: - Reducer

let loginReducer = Reducer<LoginStateCombined, LoginAction, LoginEnvironment>.combine(
    .init { state, action, environment in
        switch action {
        case .onAppear:
            #if DEBUG
            state.viewState.emailAddress = "connor.b645@gmail.com"
            state.viewState.password = "Password"
            #endif
            return .none
        case let .emailAddressChanged(emailAddress):
            state.viewState.emailAddress = emailAddress
            return .none
        case let .passwordChanged(password):
            state.viewState.password = password
            return .none
        case .passwordSecurityToggled:
            state.viewState.securePassword.toggle()
            return .none
        case .loginTapped:
            state.viewState.isLoading = true
            return .task { [state] in
                await .loginResponse(TaskResult {
                    guard environment.validate((state.viewState.emailAddress, ValidationField.email)) else {
                        throw AppeekError.validationError(.emailAddressRequired)
                    }
                    
                    return try await environment.loginClient.performLoginActions(
                        email: state.viewState.emailAddress,
                        password: state.viewState.password
                    )
                })
            }
        case let .loginResponse(.success(response)):
            state.viewState.isLoading = false
            return .task { .loggedIn }
        case let .loginResponse(.failure(error)):
            state.viewState.isLoading = false
            state.viewState.errorMessage = error.friendlyMessage
            return .none
        case .goToSignUpTapped:
            state.navigationPath.removeLast()
            return .none
        case .loggedIn:
            return .none
        default:
            return .none
        }
    },
    forgotPasswordReducer.pullback(
        state: \.forgotPasswordStateCombined,
        action: /LoginAction.forgotPasswordAction,
        environment: { ForgotPasswordEnvironment(
            resetPassword: $0.resetPassword,
            validate: $0.validate
        ) }
    )
)

// MARK: - View

struct LoginView: View {
    
    enum FocusField: Hashable {
        case email, password
    }
    
    let store: Store<LoginStateCombined, LoginAction>
    
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
                                
                                if let errorMessage = viewStore.viewState.errorMessage {
                                    error(errorMessage)
                                }
                            }
                        }
                        callToAction(viewStore: viewStore)
                    }
                    
                    if viewStore.viewState.isLoading {
                        CCProgressView(foregroundColor: .appeekPrimary,
                                       backgroundColor: .appeekBackgroundOffset)
                    }
                }
                .onAppear {
                    viewStore.send(.onAppear)
                }
                .navigationDestination(for: LoginRoute.self) { route in
                    switch route {
                    case .forgotPassword:
                        ForgotPasswordView(store: self.store.scope(
                            state: \.forgotPasswordStateCombined,
                            action: LoginAction.forgotPasswordAction
                        ))
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
    
    private func email(viewStore: ViewStore<LoginStateCombined, LoginAction>) -> some View {
        Group {
            CCEmailTextField(emailAddress: viewStore.binding(get: \.viewState.emailAddress,
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
    
    private func password(viewStore: ViewStore<LoginStateCombined, LoginAction>) -> some View {
        Group {
            HStack {
                CCPasswordTextField(password: viewStore.binding(get: \.viewState.password,
                                                                send: LoginAction.passwordChanged),
                                    isSecure: viewStore.viewState.securePassword,
                                    placeholder: "Password",
                                    foregroundColor: .appeekFont,
                                    backgroundColor: .clear)
                .submitLabel(.next)
                .focused($focusedField, equals: .password)
                .onSubmit {
                    focusedField = nil
                    viewStore.send(.loginTapped)
                }
                
                CCIconButton(iconName: viewStore.viewState.securePassword ? "lock" : "lock.open") {
                    viewStore.send(.passwordSecurityToggled)
                }
            }
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder private var forgotPassword: some View {
        NavigationLink("Forgot Password", value: LoginRoute.forgotPassword)
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
    
    private func callToAction(viewStore: ViewStore<LoginStateCombined, LoginAction>) -> some View {
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
        LoginView(store: .init(initialState: LoginStateCombined.preview,
                               reducer: loginReducer,
                               environment: LoginEnvironment.preview))
    }
}

