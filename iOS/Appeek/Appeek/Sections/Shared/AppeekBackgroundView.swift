//
//  AppeekBackgroundView.swift
//  Appeek
//
//  Created by Connor Black on 28/06/2022.
//

import SwiftUI
import ConnorsComponents

struct AppeekBackgroundView<Content: View>: View {
    @ViewBuilder var content: Content
    
    var body: some View {
        CCBackgroundView(backgroundColor: .appeekBackground) {
            content
        }
    }
}

struct AppeekBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        AppeekBackgroundView {
            Text("Hello world")
        }
    }
}
