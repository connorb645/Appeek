//
//  ContentView.swift
//  Appeek
//
//  Created by Connor Black on 27/06/2022.
//

import SwiftUI
import ConnorsComponents

struct RootView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(Color.backgroundOffset)
            Text("Hello, world!")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
