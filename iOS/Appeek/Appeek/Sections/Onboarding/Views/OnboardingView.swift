//
//  OnboardingView.swift
//  Appeek
//
//  Created by Connor Black on 28/06/2022.
//

import SwiftUI
import ConnorsComponents

struct OnboardingView: View {
    @EnvironmentObject var navigation: AppNavigation
    
    var body: some View {
        NavigationStack(path: $navigation.mainNavigation) {
            AppeekBackgroundView {
                NavigationLink("Go To Auth", value: SignUpView.Navigation())
                    .navigationDestination(for: SignUpView.Navigation.self) { _ in
                        SignUpView()
                    }
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
