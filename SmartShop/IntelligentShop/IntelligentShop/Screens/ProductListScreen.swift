//
//  ProductListScreen.swift
//  IntelligentShop
//
//  Created by Jason Sanchez on 1/30/25.
//

import SwiftUI

struct ProductListScreen: View {
    @Environment(ProductStore.self) private var productStore
    
    var body: some View {
        List(productStore.products) { product in
            Text(product.name)
        }.task {
            do {
                try await productStore.loadAllProducts()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProductListScreen()
    }.environment(ProductStore(httpClient: .development))
}
