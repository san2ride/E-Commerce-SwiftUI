//
//  CartScreen.swift
//  IntelligentShop
//
//  Created by Jason Sanchez on 3/3/25.
//

import SwiftUI

struct CartScreen: View {
    @Environment(CartStore.self) private var cartStore
    
    var body: some View {
        List {
            if let cart = cartStore.cart {
                ForEach(cart.cartItems) { cartItem in
                    Text(cartItem.product.name)
                }
            } else {
                ContentUnavailableView("No items in the cart.", systemImage: "cart")
            }
        }.task {
            try? await cartStore.loadCart()
        }
    }
}

#Preview {
    NavigationStack {
        CartScreen()
            .environment(CartStore(httpClient: .development))
    }
}
