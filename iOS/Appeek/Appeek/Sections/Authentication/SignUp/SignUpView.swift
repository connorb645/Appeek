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

struct SignUpStateWithRoute: Equatable {
    var signUpState: SignUpState
    var route: AppRoute
    
    static let preview = Self(signUpState: SignUpState.preview,
                              route: .onboarding(.init()))
}

struct SignUpState: Equatable {
    var errorMessage: String?
    var isLoading: Bool = false
    var firstName: String = ""
    var lastName: String = ""
    var emailAddress: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var passwordSecure: Bool = true
    
    static let preview = Self()
}

// MARK: - Action

enum SignUpAction: Equatable {
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
    var validationClient: ValidationClientProtocol
        
    static let preview = Self(
        signUpClient: SignUpClient.preview,
        validationClient: ValidationClient.preview)
}

// MARK: - Reducer

let signUpReducer = Reducer<SignUpState, SignUpAction, SignUpEnvironment> { state, action, environment in
    switch action {
    case .onAppear:
        #if DEBUG
        state.firstName = "Connor"
        state.lastName = "Black"
        state.emailAddress = "connor.b645@gmail.com"
        state.password = "Password"
        state.confirmPassword = "Password"
        #endif
        return .none
    case let .firstNameChanged(firstName):
        state.firstName = firstName
        return .none
    case let .lastNameChanged(lastName):
        state.lastName = lastName
        return .none
    case let .emailAddressChanged(email):
        state.emailAddress = email
        return .none
    case let .passwordChanged(password):
        state.password = password
        return .none
    case let .confirmPasswordChanged(password):
        state.confirmPassword = password
        return .none
    case .passwordSecurityToggled:
        state.passwordSecure.toggle()
        return .none
    case .createAccount:
        let firstNameValid = environment.validationClient.validate(
            (state.firstName, ValidationField.notEmpty)
        )
        let lastNameValid = environment.validationClient.validate(
            (state.lastName, ValidationField.notEmpty)
        )
        let emailValid = environment.validationClient.validate(
            (state.emailAddress, ValidationField.email)
        )
        let passwordValid = environment.validationClient.validate(
            (state.password, ValidationField.password)
        )
        let confirmPasswordValid = environment.validationClient.validate(
            (state.confirmPassword, ValidationField.confirmPassword)
        )
        
        state.isLoading = true
        
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
            guard state.password == state.confirmPassword else {
                return await .signUpResponse(TaskResult {
                    throw AppeekError.validationError(.passwordsDontMatch)
                })
            }
            return await .signUpResponse(TaskResult {
                try await environment.signUpClient.performSignUpActions(
                    email: state.emailAddress,
                    password: state.password,
                    firstName: state.firstName,
                    lastName: state.lastName
                )
            })
        }
    case let .signUpResponse(.success(response)):
        state.isLoading = false
        // TODO: - Fix this
//        state.route = AppRoute.home(.init())
        return .none
    case let .signUpResponse(.failure(error)):
        state.isLoading = false
        state.errorMessage = error.friendlyMessage
        return .none
    }
}

// MARK: - View

struct SignUpView: View {
    let store: Store<SignUpState, SignUpAction>
    
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
                                if let errorMessage = viewStore.errorMessage {
                                    error(errorMessage)
                                }
                            }
                        }
                        callToAction(viewStore)
                    }
                    if viewStore.state.isLoading {
                        CCProgressView(foregroundColor: .appeekPrimary,
                                       backgroundColor: .appeekBackgroundOffset)
                    }
                }
                .onAppear {
                    viewStore.send(.onAppear)
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
    
    @ViewBuilder private func firstName(_ viewStore: ViewStore<SignUpState, SignUpAction>) -> some View {
        Group {
            CCTextField(text: viewStore.binding(get: \.firstName,
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
    
    @ViewBuilder private func lastName(_ viewStore: ViewStore<SignUpState, SignUpAction>) -> some View {
        Group {
            CCTextField(text: viewStore.binding(get: \.lastName,
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
    
    @ViewBuilder private func email(_ viewStore: ViewStore<SignUpState, SignUpAction>) -> some View {
        Group {
            CCEmailTextField(emailAddress: viewStore.binding(get: \.emailAddress,
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
    
    @ViewBuilder private func password(_ viewStore: ViewStore<SignUpState, SignUpAction>) -> some View {
        Group {
            CCPasswordTextField(password: viewStore.binding(get: \.password,
                                                            send: SignUpAction.passwordChanged),
                                isSecure: viewStore.state.passwordSecure,
                                placeholder: "Password",
                                foregroundColor: .appeekFont,
                                backgroundColor: .clear)
            .submitLabel(.next)
            .focused($focusedField, equals: .password)
            .onSubmit {
                focusedField = .confirmPassword
            }
            
            HStack {
                CCPasswordTextField(password: viewStore.binding(get: \.confirmPassword,
                                                                send: SignUpAction.confirmPasswordChanged),
                                    isSecure: viewStore.state.passwordSecure,
                                    placeholder: "Confirm Password",
                                    foregroundColor: .appeekFont,
                                    backgroundColor: .clear)
                .submitLabel(.done)
                .focused($focusedField, equals: .confirmPassword)
                .onSubmit {
                    focusedField = nil
                    viewStore.send(.createAccount)
                }
                
                CCIconButton(iconName: viewStore.state.passwordSecure ? "lock" : "lock.open") {
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
    
    private func callToAction(_ viewStore: ViewStore<SignUpState, SignUpAction>) -> some View {
        VStack {
            CCPrimaryButton(title: "Create account!",
                            backgroundColor: .appeekPrimary) {
                viewStore.send(.createAccount)
            }
            
            NavigationLink("Already have an account? Log in!", value: OnboardingRouteStack.State.login)
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
                initialState: SignUpState.preview,
                reducer: signUpReducer,
                environment: SignUpEnvironment.preview
            )
        )
    }
}
