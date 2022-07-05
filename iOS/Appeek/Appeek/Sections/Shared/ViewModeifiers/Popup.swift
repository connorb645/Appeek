//
//  Popup.swift
//  Appeek
//
//  Created by Connor Black on 05/07/2022.
//

import SwiftUI

struct Popup<T: View>: ViewModifier {
    let popup: T
    let isPresented: Bool
    let alignment: Alignment
    
    let padding: Double = 8

    init(isPresented: Bool,
         alignment: Alignment,
         @ViewBuilder content: () -> T) {
        self.isPresented = isPresented
        self.alignment = alignment
        popup = content()
    }
    
    func body(content: Content) -> some View {
        content
            .overlay(popupContent())
    }

    @ViewBuilder private func popupContent() -> some View {
            GeometryReader { geometry in
                if isPresented {
                    popup
                        .frame(width: geometry.size.width,
                               height: geometry.size.height,
                               alignment: .top)
                        .offset(y: geometry.size.height + padding)
                        .animation(.spring(),
                                   value: isPresented)
                        .transition(.scale.combined(with: .opacity))
                        
                }
            }
        }
}

private extension GeometryProxy {
    var belowScreenEdge: CGFloat {
        UIScreen.main.bounds.height - frame(in: .global).minY
    }
}

struct Popup1_Previews: PreviewProvider {
    static var previews: some View {
        Color.clear
            .popup(isPresented: true, alignment: .center) {
                Color.yellow.frame(width: 100, height: 100)
            }
    }
}

extension View {
    func popup<T: View>(
        isPresented: Bool,
        alignment: Alignment = .center,
        @ViewBuilder content: () -> T
    ) -> some View {
        return modifier(Popup(isPresented: isPresented,
                              alignment: alignment,
                              content: content))
    }
}
