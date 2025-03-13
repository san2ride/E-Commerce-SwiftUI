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
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.1, green: 0.2, blue: 0.4), // Dark blue
                    Color(red: 0.2, green: 0.4, blue: 0.6)  // Lighter blue
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            VStack(spacing: 20) {
                Text("New Arrivals")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 40)
                ScrollView {
                    VStack(spacing: 15) {
                        if !productStore.products.isEmpty {
                            ForEach(productStore.products) { product in
                                NavigationLink {
                                    ProductDetailScreen(product: product)
                                } label: {
                                    ProductCellView(product: product)
                                        .padding()
                                        .background(Color.white.opacity(0.9))
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.blue.opacity(0.5), lineWidth: 1)
                                        )
                                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                                }
                                .buttonStyle(.plain)
                            }
                        } else {
                            VStack(spacing: 15) {
                                Image(systemName: "cart")
                                    .font(.system(size: 60))
                                    .foregroundColor(.white.opacity(0.8))
                                Text("No new arrivals available")
                                    .font(.title2)
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(16)
                        }
                    }
                    .frame(maxWidth: 400, alignment: .center)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 20)
                }
            }
            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
        }
        .navigationBarHidden(true)
        .task {
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
    }
    .environment(ProductStore(httpClient: .development))
    .environment(CartStore(httpClient: .development))
}
