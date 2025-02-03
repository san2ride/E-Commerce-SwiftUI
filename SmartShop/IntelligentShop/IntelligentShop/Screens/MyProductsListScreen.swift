//
//  MyProductsListScreen.swift
//  IntelligentShop
//
//  Created by Jason Sanchez on 2/3/25.
//

import SwiftUI

struct MyProductsListScreen: View {
    @State private var isPresented: Bool = false
    
    var body: some View {
        Text("My Product List Screen")
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Product") {
                        isPresented = true
                    }
                }
            }).sheet(isPresented: $isPresented, content: {
                NavigationStack {
                    AddProductScreen()
                }
            })
    }
}

#Preview {
    NavigationStack {
        MyProductsListScreen()
    }
}
