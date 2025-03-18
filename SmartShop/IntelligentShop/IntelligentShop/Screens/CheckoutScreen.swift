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
    @Environment(OrderStore.self) private var orderStore
    @Environment(CartStore.self) private var cartStore
    @State private var paymentSheet: PaymentSheet?
    @State private var presentOrderConfirmationScreen: Bool = false
    
    private func paymentCompletion(result: PaymentSheetResult) {
        switch result {
            case .completed:
                Task {
                    do {
                        // convert cart to order
                        let order = Order(from: cart)
                        // save the order
                        try await orderStore.saveOrder(order: order)
                        // empty the cart
                        cartStore.emptyCart()
                        // present order confirmation screen
                        presentOrderConfirmationScreen = true
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                
            case .canceled:
                print("Payment canceled")
            case .failed(let error):
                print(error)
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
                            if let paymentSheet = paymentSheet {
                                PaymentSheet.PaymentButton(
                                    paymentSheet: paymentSheet,
                                    onCompletion: paymentCompletion
                                ) {
                                    Text("Place Your Order")
                                        .fontWeight(.bold)
                                        .frame(maxWidth: .infinity)
                                        //.padding()
                                        .background(Color.blue) // Matches app theme
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                                .padding(.horizontal, 15) // Matches inner card padding
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
        .navigationDestination(isPresented: $presentOrderConfirmationScreen) {
            OrderConfirmationScreen()
                .navigationBarBackButtonHidden()
        }
        .task {
            do {
                paymentSheet = try await paymentController.preparePaymentSheet(for: cart)
            } catch {
                print(error.localizedDescription)
            }
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
    .environment(OrderStore(httpClient: .development))
    .environment(\.paymentController, PaymentController(httpClient: .development))
}
