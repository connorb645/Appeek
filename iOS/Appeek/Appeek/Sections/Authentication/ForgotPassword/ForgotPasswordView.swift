//
//  ForgotPasswordView.swift
//  Appeek
//
//  Created by Connor Black on 30/06/2022.
//

import SwiftUI
import ConnorsComponents
import ComposableArchitecture

struct ForgotPasswordView: View {
    enum FocusField: Hashable {
        case email
    }
    
    let store: Store<ForgotPasswordStateCombined, ForgotPasswordAction>
    
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
    
    private func email(_ viewStore: ViewStore<ForgotPasswordStateCombined, ForgotPasswordAction>) -> some View {
        Group {
            CCEmailTextField(emailAddress: viewStore.binding(get: \.viewState.emailAddress,
                                                             send: ForgotPasswordAction.onEmailChanged),
                             placeholder: "Email Address",
                             foregroundColor: .appeekFont,
                             backgroundColor: .clear)
            .submitLabel(.next)
            .focused($focusedField, equals: .email)
            .onSubmit {
                focusedField = nil
                viewStore.send(.submitTapped)
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
    
    private func callToAction(_ viewStore: ViewStore<ForgotPasswordStateCombined, ForgotPasswordAction>) -> some View {
        VStack {
            CCPrimaryButton(title: "Reset password",
                            backgroundColor: .appeekPrimary) {
                viewStore.send(.submitTapped)
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .padding()
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView(store: .init(initialState: ForgotPasswordStateCombined.preview,
                                        reducer: forgotPasswordReducer,
                                        environment: ForgotPasswordEnvironment.preview))
    }
}
