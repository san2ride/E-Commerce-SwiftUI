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
            try await productStore.loadMyProducts(by: userId)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        List(productStore.myProducts) { product in
            NavigationLink {
                MyProductDetailScreen(product: product)
            } label: {
                MyProductCellView(product: product)
            }
        }
        .listStyle(.plain)
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
        .overlay(alignment: .center) {
            if productStore.myProducts.isEmpty {
                ContentUnavailableView("No products available", systemImage: "cart")
            }
        }
    }
}
#Preview {
    NavigationStack {
        MyProductListScreen()
    }.environment(ProductStore(httpClient: .development))
}
