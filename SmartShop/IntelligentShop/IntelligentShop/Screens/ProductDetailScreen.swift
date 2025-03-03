//
//  ProductDetailScreen.swift
//  IntelligentShop
//
//  Created by Jason Sanchez on 3/2/25.
//

import SwiftUI

struct ProductDetailScreen: View {
    let product: Product
    @Environment(CartStore.self) private var cartStore
    @State private var quantity: Int = 1
    
    var body: some View {
        ScrollView {
            AsyncImage(url: product.photoUrl) { image in
                image.resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            Text(product.name)
                .font(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(product.description)
                .padding([.top], 5)
            Text(product.price, format: .currency(code: "USD"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title)
                .bold()
                .padding([.top], 3)
            Stepper(value: $quantity) {
                Text("Quantity: \(quantity)")
            }
            Button {
                Task {
                    do {
                        try await cartStore.addItemToCart(productId: product.id!,
                                                          quantity: quantity)
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Add to cart")
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .foregroundStyle(.white)
                    .background(.cyan)
                    .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
            }
        }.padding()
    }
}
#Preview {
    ProductDetailScreen(product: Product.preview)
        .environment(CartStore(httpClient: .development))
}
