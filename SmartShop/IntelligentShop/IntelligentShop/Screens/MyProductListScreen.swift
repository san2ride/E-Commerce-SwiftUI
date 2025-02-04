//
//  MyProductListScreen.swift
//  IntelligentShop
//
//  Created by Jason Sanchez on 2/3/25.
//

import SwiftUI

struct MyProductListScreen: View {
    @Environment(ProductStore.self) private var productStore
    @State private var isPresented: Bool = false
    @AppStorage("userId") private var userId: Int?
    
    private func loadMyProducts() async {
        do {
            guard let userId = userId else {
                throw UserError.missingId
            }
            try await productStore.loadMyProducts(by: 9)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        List(productStore.myProducts) { product in
            Text(product.name)
        }
        .task {
            await loadMyProducts()
        }
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
        MyProductListScreen()
    }.environment(ProductStore(httpClient: .development))
}
