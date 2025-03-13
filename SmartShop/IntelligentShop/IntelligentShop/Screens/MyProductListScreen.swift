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
                    // Header
                    Text("My Products")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 40)
                    // Products Content
                    ScrollView {
                        VStack(spacing: 20) {
                            // Products List Section
                            if !productStore.myProducts.isEmpty {
                                VStack(spacing: 15) {
                                    ForEach(productStore.myProducts) { product in
                                        NavigationLink {
                                            MyProductDetailScreen(product: product)
                                        } label: {
                                            MyProductCellView(product: product)
                                                .padding()
                                                .background(Color.white.opacity(0.9))
                                                .cornerRadius(10)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .stroke(Color.blue.opacity(0.5), lineWidth: 1)
                                                )
                                        }
                                        .buttonStyle(.plain) // Keeps the link style clean
                                    }
                                }
                                .padding()
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(15)
                            }
                            // Overlay for empty state or error
                            if let message = message {
                                VStack(spacing: 15) {
                                    Image(systemName: "exclamationmark.triangle")
                                        .font(.system(size: 60))
                                        .foregroundColor(.white.opacity(0.8))
                                    /*
                                    Text(message)
                                        .font(.title2)
                                        .foregroundColor(.red)
                                        .multilineTextAlignment(.center)
                                     */
                                }
                                .padding()
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(15)
                            } else if productStore.myProducts.isEmpty {
                                VStack(spacing: 15) {
                                    Image(systemName: "cart") // Changed from heart to match pest-control theme
                                        .font(.system(size: 60))
                                        .foregroundColor(.white.opacity(0.8))
                                    Text("No products available")
                                        .font(.title2)
                                        .foregroundColor(.white)
                                }
                                .padding()
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(15)
                            }
                        }
                        .padding(.horizontal, 30)
                        .padding(.bottom, 20)
                    }
                }
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                // Add Product Button (floating)
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            isPresented = true
                        }) {
                            Image(systemName: "plus")
                                .font(.title2)
                                .frame(width: 60, height: 60)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
            .task {
                await loadMyProducts()
            }
            .sheet(isPresented: $isPresented) {
                NavigationStack {
                    AddProductScreen()
                }
            }
            .navigationBarHidden(true)
    }
}

#Preview {
    NavigationStack {
        MyProductListScreen()
    }.environment(ProductStore(httpClient: .development))
}
