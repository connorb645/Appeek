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
    var emailAddress: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var passwordSecure: Bool = true
    
    static let preview = Self()
}

// MARK: - Action

enum SignUpAction: Equatable {
    case emailAddressChanged(String)
    case passwordChanged(String)
    case confirmPasswordChanged(String)
    case passwordSecurityToggled
    case createAccount
    case creationResponse(Result<AuthSession, AppeekError>)
    case sessionPersistenceResponse(Result<AuthSession, AppeekError>)
}

// MARK: - Environment

struct SignUpEnvironment {
    var createAccount: (String, String) -> Effect<AuthSession, AppeekError>
    var persist: (AuthSession) -> Effect<AuthSession, AppeekError>
    var validationClient: ValidationClientProtocol
    
    var mainQueue: AnySchedulerOf<DispatchQueue>
    
    static let preview = Self(createAccount: AuthenticateClient.preview.createAccount(email:password:),
                              persist: AuthenticateClient.preview.persist(authSession:),
                              validationClient: ValidationClient.preview,
                              mainQueue: .immediate)
}

// MARK: - Reducer

let signUpReducer = Reducer<SignUpStateWithRoute, SignUpAction, SignUpEnvironment> { state, action, environment in
    switch action {
    case let .emailAddressChanged(email):
        state.signUpState.emailAddress = email
        return .none
    case let .passwordChanged(password):
        state.signUpState.password = password
        return .none
    case let .confirmPasswordChanged(password):
        state.signUpState.confirmPassword = password
        return .none
    case .passwordSecurityToggled:
        state.signUpState.passwordSecure.toggle()
        return .none
    case .createAccount:
        let emailValid = environment.validationClient.validate(
            (state.signUpState.emailAddress, ValidationField.email)
        )
        let passwordValid = environment.validationClient.validate(
            (state.signUpState.password, ValidationField.password)
        )
        let confirmPasswordValid = environment.validationClient.validate(
            (state.signUpState.confirmPassword, ValidationField.confirmPassword)
        )
        guard emailValid else {
            return Effect(value: SignUpAction.creationResponse(
                .failure(.validationError(.emailAddressRequired))
            ))
        }
        guard passwordValid else {
            return Effect(value: SignUpAction.creationResponse(
                .failure(.validationError(.passwordRequired))
            ))
        }
        guard confirmPasswordValid else {
            return Effect(value: SignUpAction.creationResponse(
                .failure(.validationError(.passwordConfirmationRequired))
            ))
        }
        guard state.signUpState.password == state.signUpState.confirmPassword else {
            return Effect(value: SignUpAction.creationResponse(
                .failure(.validationError(.passwordsDontMatch))
            ))
        }
        state.signUpState.isLoading = true
        return environment
            .createAccount(state.signUpState.emailAddress, state.signUpState.password)
            .receive(on: environment.mainQueue)
            .catchToEffect(SignUpAction.creationResponse)
    case let .creationResponse(.success(response)):
        state.signUpState.isLoading = false
        return environment.persist(response)
            .receive(on: environment.mainQueue)
            .catchToEffect(SignUpAction.sessionPersistenceResponse)
    case let .creationResponse(.failure(error)):
        state.signUpState.isLoading = false
        state.signUpState.errorMessage = error.friendlyMessage
        return .none
    case let .sessionPersistenceResponse(.success(authSession)):
        state.route = AppRoute.home(.init())
        return .none
    case let .sessionPersistenceResponse(.failure(error)):
        state.signUpState.errorMessage = error.friendlyMessage
        return .none
    }
}

// MARK: - View

struct SignUpView: View {
    let store: Store<SignUpStateWithRoute, SignUpAction>
    
    enum FocusField: Hashable {
        case email, password, confirmPassword
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
                                
                                email(viewStore)
                                
                                Divider()
                                
                                password(viewStore)
                                
                                Divider()
                                
                                if let errorMessage = viewStore.state.signUpState.errorMessage {
                                    error(errorMessage)
                                }
                            }
                        }
                                        
                        callToAction(viewStore)
                    }
                    
                    if viewStore.state.signUpState.isLoading {
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
        
        Text("Create your account")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.title)
            .fontWeight(.bold)
            .padding(.horizontal)
            .padding(.top)
    }
    
    @ViewBuilder private func email(_ viewStore: ViewStore<SignUpStateWithRoute, SignUpAction>) -> some View {
        Group {
            CCEmailTextField(emailAddress: viewStore.binding(get: \.signUpState.emailAddress,
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
    
    @ViewBuilder private func password(_ viewStore: ViewStore<SignUpStateWithRoute, SignUpAction>) -> some View {
        Group {
            CCPasswordTextField(password: viewStore.binding(get: \.signUpState.password,
                                                            send: SignUpAction.passwordChanged),
                                isSecure: viewStore.state.signUpState.passwordSecure,
                                placeholder: "Password",
                                foregroundColor: .appeekFont,
                                backgroundColor: .clear)
            .submitLabel(.next)
            .focused($focusedField, equals: .password)
            .onSubmit {
                focusedField = .confirmPassword
            }
            
            HStack {
                CCPasswordTextField(password: viewStore.binding(get: \.signUpState.confirmPassword,
                                                                send: SignUpAction.confirmPasswordChanged),
                                    isSecure: viewStore.state.signUpState.passwordSecure,
                                    placeholder: "Confirm Password",
                                    foregroundColor: .appeekFont,
                                    backgroundColor: .clear)
                .submitLabel(.done)
                .focused($focusedField, equals: .confirmPassword)
                .onSubmit {
                    focusedField = nil
                    viewStore.send(.createAccount)
                }
                
                CCIconButton(iconName: viewStore.state.signUpState.passwordSecure ? "lock" : "lock.open") {
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
    
    private func callToAction(_ viewStore: ViewStore<SignUpStateWithRoute, SignUpAction>) -> some View {
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
                initialState: SignUpStateWithRoute.preview,
                reducer: signUpReducer,
                environment: SignUpEnvironment.preview
            )
        )
    }
}
