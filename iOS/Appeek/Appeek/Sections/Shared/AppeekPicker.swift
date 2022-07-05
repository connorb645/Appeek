//
//  AppeekPicker.swift
//  Appeek
//
//  Created by Connor Black on 04/07/2022.
//

import ConnorsComponents
import SwiftUI

struct AppeekPicker<Item: AppeekPickable & Hashable>: View {
    var items: [Item]
    var isLoading: Bool = true
    
    @State var isExpanded: Bool = false
    @Binding var selectedItem: Item?
    
    var body: some View {
        picker
            .popup(isPresented: isExpanded, alignment: .top) {
            selectionList
        }
    }
    
    @ViewBuilder var picker: some View {
        Button {
            handleToggle()
        } label: {
            ZStack {
                HStack {
                    if isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                    } else {
                        Text(selectedItem?.title ?? "No Selection")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                    }

                    Image(systemName: "chevron.down")
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        .padding()
                        
                }
            }
            .background(Color.appeekBackgroundOffset)
            .cornerRadius(5)
        }
        .tint(.appeekFont)

    }
    
    @ViewBuilder var selectionList: some View {
        ZStack {
            VStack {
                ForEach(items, id:\.self) { item in
                    itemView(item)
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .background(Color.appeekBackgroundOffset)
        .cornerRadius(5)
    }
    
    @ViewBuilder func itemView(_ item: Item) -> some View {
        Button {
            self.selectedItem = item
            self.handleToggle()
        } label: {
            Text(item.title)
                .frame(height: 20)
                .frame(maxWidth: .infinity)
                .foregroundColor(.appeekFont)
        }

    }
    
    func handleToggle() {
        withAnimation(Animation.spring()) {
            isExpanded.toggle()
        }
    }
}

struct AppeekPicker_Previews: PreviewProvider {
    static var previews: some View {
        let o1 = Organisation(id: .init(),
                                         name: "Org One",
                                         createdAt: "SomeString")
        let o2 = Organisation(id: .init(),
                                         name: "Org Two",
                                         createdAt: "SomeString")
        let o3 = Organisation(id: .init(),
                                         name: "Org One",
                                         createdAt: "SomeString")
        let o4 = Organisation(id: .init(),
                                         name: "Org Two",
                                         createdAt: "SomeString")
        let orgs: [Organisation] = [o1,o2, o3, o4]
        AppeekPicker(items: orgs,
                     selectedItem: .constant(nil))
    }
}

protocol AppeekPickable {
    var title: String { get }
}
