//
//  CartScreen.swift
//  IntelligentShop
//
//  Created by Jason Sanchez on 3/3/25.
//

import SwiftUI

struct CartScreen: View {
    @Environment(CartStore.self) private var cartStore
    @AppStorage("userId") private var userId: Int?
    @State private var proceedToCheckout = false

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.1, green: 0.2, blue: 0.4),  // Dark blue
                    Color(red: 0.2, green: 0.4, blue: 0.6),  // Lighter blue
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            VStack(spacing: 20) {
                // Header
                Text("Your Cart")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 40)
                // Cart Content
                ScrollView {
                    VStack(spacing: 20) {
                        if let cart = cartStore.cart {
                            // Total Section
                            VStack(spacing: 15) {
                                HStack {
                                    Text("Total:")
                                        .font(.title2)
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text(
                                        cart.total,
                                        format: .currency(code: "USD")
                                    )
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                }
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(10)

                                // Checkout Button
                                Button(action: {
                                    proceedToCheckout = true
                                }) {
                                    Text(
                                        "Proceed to Checkout ^[(\(cart.itemsCount) Item](inflect: true))"
                                    )
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                }
                                .buttonStyle(.borderless)
                            }
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(15)
                            // Cart Items Section
                            VStack(spacing: 15) {
                                Text("Items")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                CartItemListView(cartItems: cart.cartItems)
                                    .padding()
                                    .background(Color.white.opacity(0.9))
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(
                                                Color.blue.opacity(0.5),
                                                lineWidth: 1)
                                    )
                            }
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(15)
                        } else {
                            // Empty Cart View
                            VStack(spacing: 15) {
                                Image(systemName: "cart")
                                    .font(.system(size: 60))
                                    .foregroundColor(.white.opacity(0.8))
                                Text("No items in the cart.")
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
        }
        .navigationDestination(isPresented: $proceedToCheckout) {
            if let cart = cartStore.cart {
                CheckoutScreen(cart: cart)
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    NavigationStack {
        CartScreen()
            .environment(CartStore(httpClient: .development))
    }
}
