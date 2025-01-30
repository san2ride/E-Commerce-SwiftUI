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
        VStack(alignment: .leading, spacing: 10) {
            AsyncImage(url: product.photoUrl) { image in
                image.resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
                    .scaledToFit()
            } placeholder: {
                ProgressView("Loading...")
            }
            
            Text(product.name)
                .font(.title)
            
            Text(product.price, format: .currency(code: "USD"))
                .font(.title2)
        }.padding()
    }
}

#Preview {
    ProductCellView(product: Product.preview)
}
