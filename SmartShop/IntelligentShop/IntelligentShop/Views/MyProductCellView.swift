//
//  MyProductCellView.swift
//  IntelligentShop
//
//  Created by Jason Sanchez on 2/19/25.
//

import SwiftUI

struct MyProductCellView: View {
    let product: Product
    
    var body: some View {
        HStack(alignment: .top) {
            AsyncImage(url: product.photoUrl) { img in
                img.resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
                    .frame(width: 100, height: 100)
            } placeholder: {
                ProgressView("Loading...")
            }
            Spacer()
                .frame(width: 20)
            VStack {
                Text(product.name)
                    .font(.title3)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(product.price, format: .currency(code: "USD"))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

#Preview {
    NavigationStack {
        MyProductCellView(product: Product.preview)
    }.environment(ProductStore(httpClient: .development))
}
