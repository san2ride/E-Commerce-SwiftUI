//
//  CheckoutScreen.swift
//  IntelligentShop
//
//  Created by Jason Sanchez on 3/11/25.
//

import SwiftUI
import StripePaymentSheet

struct CheckoutScreen: View {
    let cart: Cart
    
    @Environment(\.paymentController) private var paymentController
    @Environment(UserStore.self) private var userStore
    @State private var paymentSheet: PaymentSheet?
    
    private func paymentCompletion(result: PaymentSheetResult) {
        print(result)
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
                Text("Checkout")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 40)
                // Checkout Card
                ScrollView {
                    VStack(spacing: 20) {
                        // Order Summary Section
                        VStack(spacing: 15) {
                            Text("Place Your Order")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            HStack {
                                Text("Items: (\(cart.itemsCount))")
                                    .foregroundColor(.white)
                                Spacer()
                                Text(cart.total, format: .currency(code: "USD"))
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                            }
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(10)
                            if let userInfo = userStore.userInfo {
                                Text("Delivering to \(userInfo.fullName)")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("\(userInfo.address)")
                                    .foregroundColor(.white.opacity(0.9))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.subheadline)
                            } else {
                                Text("Please update your profile and add the missing information.")
                                    .foregroundColor(.red)
                                    .font(.caption)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(15)
                        // Cart Items Section
                        VStack(spacing: 15) {
                            Text("Order Items")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            ForEach(cart.cartItems) { cartItem in
                                CartItemView(cartItem: cartItem)
                                    .padding()
                                    .background(Color.white.opacity(0.9))
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.blue.opacity(0.5), lineWidth: 1)
                                    )
                            }
                            if let paymentSheet {
                                PaymentSheet.PaymentButton(paymentSheet: paymentSheet,
                                                           onCompletion: paymentCompletion) {
                                    Text("Place your order")
                                        .bold()
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.red)
                                        .foregroundStyle(.white)
                                        .cornerRadius(8)
                                        .padding()
                                        .buttonStyle(.borderless)
                                    
                                }
                            }
                        }.task {
                            do {
                                paymentSheet = try await paymentController.preparePaymentSheet(for: cart)
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(15)
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 20)
                }
            }
            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    NavigationStack {
        CheckoutScreen(cart: Cart.preview)
    }
    .environment(UserStore(httpClient: .development))
    .environment(CartStore(httpClient: .development))
    .environment(\.paymentController, PaymentController(httpClient: .development))
}
