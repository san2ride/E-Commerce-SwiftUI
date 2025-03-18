//
//  OrderConfirmationScreen.swift
//  IntelligentShop
//
//  Created by Jason Sanchez on 3/17/25.
//

import SwiftUI

struct OrderConfirmationScreen: View {
    @State private var navigateToProductList = false
    
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
            VStack(spacing: 30) {
                Spacer()
                // Confirmation Icon
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                // Title
                Text("Order Placed Successfully!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                // Description
                Text("Thank you for your purchase! Your order has been successfully placed. We are preparing it for shipment.")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                // Continue Shopping Button
                Button(action: {
                    navigateToProductList = true
                }) {
                    Text("Continue Shopping")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 30)
                
                Spacer()
            }
            .padding()
            .background(Color.white.opacity(0.2))
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
            .padding(.horizontal, 30)
        }
        .navigationTitle("Order Confirmation")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar) // White title
        .toolbarBackground(.hidden, for: .navigationBar) // Keeps gradient visible
        .navigationDestination(isPresented: $navigateToProductList) {
            ProductListScreen()
        }
    }
}

#Preview {
    NavigationStack {
        OrderConfirmationScreen()
            .environment(ProductStore(httpClient: .development))
    }
}
