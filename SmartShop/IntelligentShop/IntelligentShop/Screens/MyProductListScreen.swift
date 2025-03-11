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
    @State private var message: String?
    
    private func loadMyProducts() async {
        do {
            guard let userId = userId else {
                throw UserError.missingId
            }
            try await productStore.loadMyProducts(by: userId)
        } catch {
            message = error.localizedDescription
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
            if let message {
                Text(message)
            } else if productStore.myProducts.isEmpty {
                ContentUnavailableView("No products available", systemImage: "skull")
            }
        }
    }
}
#Preview {
    NavigationStack {
        MyProductListScreen()
    }.environment(ProductStore(httpClient: .development))
}
