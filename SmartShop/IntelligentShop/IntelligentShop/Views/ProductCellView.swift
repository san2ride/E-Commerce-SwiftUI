//
//  ProductCellView.swift
//  IntelligentShop
//
//  Created by Jason Sanchez on 1/30/25.
//

import SwiftUI

struct ProductCellView: View {
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Product Image
            AsyncImage(url: product.photoUrl) { image in
                image.resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .scaledToFit()
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.blue.opacity(0.5), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
            } placeholder: {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.blue))
                    .frame(maxWidth: .infinity, maxHeight: 200)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(16)
            }
            .frame(maxWidth: .infinity , maxHeight: 200) // Consistent image height
            // Product Name
            Text(product.name)
                .font(.title2) // Slightly smaller for better hierarchy
                .fontWeight(.semibold)
                .foregroundColor(.blue) // Black for contrast on white background
                .lineLimit(2)
            // Product Price
            Text(product.price, format: .currency(code: "USD"))
                .font(.title) // Slightly smaller than title2
                .fontWeight(.bold)
                .foregroundColor(Color.blue) // Blue to tie into theme
        }
        .padding(15) // Inner padding for content
        // Note: Outer padding, background, and border are handled by ProductListScreen
    }
}

#Preview {
    ProductCellView(product: Product.preview)
}
