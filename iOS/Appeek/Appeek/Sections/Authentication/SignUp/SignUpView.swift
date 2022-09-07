//
//  SignUpView.swift
//  Appeek
//
//  Created by Connor Black on 28/06/2022.
//

import SwiftUI
import ConnorsComponents
import ComposableArchitecture

// MARK: - State

struct SignUpStateCombined: Equatable {
    var viewState: SignUpState
    var navigationPath: NavigationPath

    var loginStateCombined: LoginStateCombined {
        get {
            .init(viewState: viewState.loginState,
                  navigationPath: navigationPath)
        }
        set {
            self.viewState.loginState = newValue.viewState
            self.navigationPath = newValue.navigationPath
        }
    }
    
    init(
        viewState: SignUpState,
        navigationPath: NavigationPath
    ) {
        self.viewState = viewState
        self.navigationPath = navigationPath
    }
    
    static let preview = Self(viewState: SignUpState.preview,
                              navigationPath: .init())
}

enum SignUpRoute: Equatable {
    case login
}

struct SignUpState: Equatable {
    
    // TODO: - clean into prop wrap
    var loginState: LoginState {
        get {
            self._loginState ?? .init()
        }
        set {
            self._loginState = newValue
        }
    }
    private var _loginState: LoginState?
    
    var errorMessage: String?
    var isLoading: Bool
    var firstName: String
    var lastName: String
    var emailAddress: String
    var password: String
    var confirmPassword: String
    var passwordSecure: Bool
    
    init(errorMessage: String? = nil,
         isLoading: Bool = false,
         firstName: String = "",
         lastName: String = "",
         emailAddress: String = "",
         password: String = "",
         confirmPassword: String = "",
         passwordSecure: Bool = true) {
        self.errorMessage = errorMessage
        self.isLoading = isLoading
        self.firstName = firstName
        self.lastName = lastName
        self.emailAddress = emailAddress
        self.password = password
        self.confirmPassword = confirmPassword
        self.passwordSecure = passwordSecure
    }
    
    static let preview = Self()
}

// MARK: - Action

enum SignUpAction: Equatable {
    case loginAction(LoginAction)
    
    case onAppear
    case firstNameChanged(String)
    case lastNameChanged(String)
    case emailAddressChanged(String)
    case passwordChanged(String)
    case confirmPasswordChanged(String)
    case passwordSecurityToggled
    case createAccount
    case signUpResponse(TaskResult<Void>)
    
    static func == (lhs: SignUpAction, rhs: SignUpAction) -> Bool {
        switch (lhs, rhs) {
        case (.onAppear, .onAppear):
            return true
        case (let .firstNameChanged(l), let .firstNameChanged(r)):
            return l == r
        case (let .lastNameChanged(l), let .lastNameChanged(r)):
            return l == r
        case (let .emailAddressChanged(l), let .emailAddressChanged(r)):
            return l == r
        case (let .passwordChanged(l), let .passwordChanged(r)):
            return l == r
        case (let .confirmPasswordChanged(l), let .confirmPasswordChanged(r)):
            return l == r
        case (.createAccount, .createAccount):
            return true
        case (.signUpResponse, .signUpResponse):
            return true
        default:
            return false
        }
    }
}

// MARK: - Environment

struct SignUpEnvironment {
    var signUpClient: SignUpClient
    var loginClient: LoginClient
    var validationClient: ValidationClientProtocol
    var resetPassword: (String) async throws -> Void
        
    static let preview = Self(
        signUpClient: SignUpClient.preview,
        loginClient: LoginClient.preview,
        validationClient: ValidationClient.preview,
        resetPassword: { _ in })
}

// MARK: - Reducer

let signUpReducer = Reducer<SignUpStateCombined, SignUpAction, SignUpEnvironment>.combine(
    .init { state, action, environment in
        switch action {
        case .onAppear:
            #if DEBUG
            state.viewState.firstName = "Connor"
            state.viewState.lastName = "Black"
            state.viewState.emailAddress = "connor.b645@gmail.com"
            state.viewState.password = "Password"
            state.viewState.confirmPassword = "Password"
            #endif
            return .none
        case let .firstNameChanged(firstName):
            state.viewState.firstName = firstName
            return .none
        case let .lastNameChanged(lastName):
            state.viewState.lastName = lastName
            return .none
        case let .emailAddressChanged(email):
            state.viewState.emailAddress = email
            return .none
        case let .passwordChanged(password):
            state.viewState.password = password
            return .none
        case let .confirmPasswordChanged(password):
            state.viewState.confirmPassword = password
            return .none
        case .passwordSecurityToggled:
            state.viewState.passwordSecure.toggle()
            return .none
        case .createAccount:
            let firstNameValid = environment.validationClient.validate(
                (state.viewState.firstName, ValidationField.notEmpty)
            )
            let lastNameValid = environment.validationClient.validate(
                (state.viewState.lastName, ValidationField.notEmpty)
            )
            let emailValid = environment.validationClient.validate(
                (state.viewState.emailAddress, ValidationField.email)
            )
            let passwordValid = environment.validationClient.validate(
                (state.viewState.password, ValidationField.password)
            )
            let confirmPasswordValid = environment.validationClient.validate(
                (state.viewState.confirmPassword, ValidationField.confirmPassword)
            )
            
            state.viewState.isLoading = true
            
            return .task { [state = state] in
                guard firstNameValid else {
                    return await .signUpResponse(TaskResult {
                        throw AppeekError.validationError(.firstNameRequired)
                    })
                }
                guard lastNameValid else {
                    return await .signUpResponse(TaskResult {
                        throw AppeekError.validationError(.lastNameRequired)
                    })
                }
                guard emailValid else {
                    return await .signUpResponse(TaskResult {
                        throw AppeekError.validationError(.emailAddressRequired)
                    })
                }
                guard passwordValid else {
                    return await .signUpResponse(TaskResult {
                        throw AppeekError.validationError(.passwordRequired)
                    })
                }
                guard confirmPasswordValid else {
                    return await .signUpResponse(TaskResult {
                        throw AppeekError.validationError(.passwordConfirmationRequired)
                    })
                }
                guard state.viewState.password == state.viewState.confirmPassword else {
                    return await .signUpResponse(TaskResult {
                        throw AppeekError.validationError(.passwordsDontMatch)
                    })
                }
                return await .signUpResponse(TaskResult {
                    try await environment.signUpClient.performSignUpActions(
                        email: state.viewState.emailAddress,
                        password: state.viewState.password,
                        firstName: state.viewState.firstName,
                        lastName: state.viewState.lastName
                    )
                })
            }
        case let .signUpResponse(.success(response)):
            state.viewState.isLoading = false
            state.navigationPath = .init()
            return .none
        case let .signUpResponse(.failure(error)):
            state.viewState.isLoading = false
            state.viewState.errorMessage = error.friendlyMessage
            return .none
        default:
            return .none
        }
    },
    loginReducer.pullback(
        state: \.loginStateCombined,
        action: /SignUpAction.loginAction,
        environment: { LoginEnvironment(loginClient: $0.loginClient,
                                        validate: $0.validationClient.validate(_:),
                                        resetPassword: $0.resetPassword) }
    )
)

// MARK: - View

struct SignUpView: View {
    let store: Store<SignUpStateCombined, SignUpAction>
    
    enum FocusField: Hashable {
        case firstName,
             lastName,
             email,
             password,
             confirmPassword
    }

    // TODO: - Neeed to take this focus field out of the view.
    @FocusState private var focusedField: FocusField?
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            AppeekBackgroundView {
                ZStack {
                    VStack {
                        ScrollView {
                            VStack {
                                header
                                firstName(viewStore)
                                lastName(viewStore)
                                Divider()
                                email(viewStore)
                                Divider()
                                password(viewStore)
                                Divider()
                                if let errorMessage = viewStore.viewState.errorMessage {
                                    error(errorMessage)
                                }
                            }
                        }
                        callToAction(viewStore)
                    }
                    if viewStore.viewState.isLoading {
                        CCProgressView(foregroundColor: .appeekPrimary,
                                       backgroundColor: .appeekBackgroundOffset)
                    }
                }
                .onAppear {
                    viewStore.send(.onAppear)
                }
            }
            .navigationDestination(for: SignUpRoute.self) { route in
                switch route {
                case .login:
                    LoginView(store: self.store.scope(state: \.loginStateCombined,
                                                      action: SignUpAction.loginAction))
                }
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
    
    @ViewBuilder private func firstName(_ viewStore: ViewStore<SignUpStateCombined, SignUpAction>) -> some View {
        Group {
            CCTextField(text: viewStore.binding(get: \.viewState.firstName,
                                                send: SignUpAction.firstNameChanged),
                        placeholder: "First Name",
                        foregroundColor: .appeekFont,
                        backgroundColor: .clear)
            .submitLabel(.next)
            .focused($focusedField, equals: .firstName)
            .onSubmit {
                focusedField = .lastName
            }
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder private func lastName(_ viewStore: ViewStore<SignUpStateCombined, SignUpAction>) -> some View {
        Group {
            CCTextField(text: viewStore.binding(get: \.viewState.lastName,
                                                send: SignUpAction.lastNameChanged),
                        placeholder: "Last Name",
                        foregroundColor: .appeekFont,
                        backgroundColor: .clear)
            .submitLabel(.next)
            .focused($focusedField, equals: .lastName)
            .onSubmit {
                focusedField = .email
            }
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder private func email(_ viewStore: ViewStore<SignUpStateCombined, SignUpAction>) -> some View {
        Group {
            CCEmailTextField(emailAddress: viewStore.binding(get: \.viewState.emailAddress,
                                                             send: SignUpAction.emailAddressChanged),
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
    
    @ViewBuilder private func password(_ viewStore: ViewStore<SignUpStateCombined, SignUpAction>) -> some View {
        Group {
            CCPasswordTextField(password: viewStore.binding(get: \.viewState.password,
                                                            send: SignUpAction.passwordChanged),
                                isSecure: viewStore.viewState.passwordSecure,
                                placeholder: "Password",
                                foregroundColor: .appeekFont,
                                backgroundColor: .clear)
            .submitLabel(.next)
            .focused($focusedField, equals: .password)
            .onSubmit {
                focusedField = .confirmPassword
            }
            
            HStack {
                CCPasswordTextField(password: viewStore.binding(get: \.viewState.confirmPassword,
                                                                send: SignUpAction.confirmPasswordChanged),
                                    isSecure: viewStore.viewState.passwordSecure,
                                    placeholder: "Confirm Password",
                                    foregroundColor: .appeekFont,
                                    backgroundColor: .clear)
                .submitLabel(.done)
                .focused($focusedField, equals: .confirmPassword)
                .onSubmit {
                    focusedField = nil
                    viewStore.send(.createAccount)
                }
                
                CCIconButton(iconName: viewStore.viewState.passwordSecure ? "lock" : "lock.open") {
                    viewStore.send(.passwordSecurityToggled)
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
    
    private func callToAction(_ viewStore: ViewStore<SignUpStateCombined, SignUpAction>) -> some View {
        VStack {
            CCPrimaryButton(title: "Create account!",
                            backgroundColor: .appeekPrimary) {
                viewStore.send(.createAccount)
            }
            
            NavigationLink("Already have an account? Log in!", value: SignUpRoute.login)
                .frame(height: 45)
                .foregroundColor(.appeekPrimary)
                
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .padding()
    }
}

// MARK: - Preview

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(
            store: .init(
                initialState: SignUpStateCombined.preview,
                reducer: signUpReducer,
                environment: SignUpEnvironment.preview
            )
        )
    }
}
