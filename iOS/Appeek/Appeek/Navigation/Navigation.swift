//
//  Navigation.swift
//  Appeek
//
//  Created by Connor Black on 28/06/2022.
//

import Foundation
import SwiftUI

enum Page: String, Identifiable, Hashable {
    var id: String { self.rawValue }
    
    case onboarding,
         signUp,
         login
}

class AppNavigation: ObservableObject {
    @Published var mainNavigation: NavigationPath = NavigationPath()
}

//struct Page: Identifiable, Hashable {
//    var id: Int { pageType.rawValue }
//    let pageType: PageType
//
//    init(pageType: PageType) {
//        self.pageType = pageType
//    }
//}
//
//class Navigation: ObservableObject {
//    @Published var pages: [Page] = []
//    
//    @ViewBuilder func view(for page: Page) -> some View {
//        switch page.pageType {
//        case .onboarding:
//            OnboardingView(navigation: self)
//        case .createAccount:
//            SignUpView(navigation: self)
//        case .login:
//            Text("Login")
//        }
//    }
//}
