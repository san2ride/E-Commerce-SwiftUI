//
//  AddProductScreen.swift
//  IntelligentShop
//
//  Created by Jason Sanchez on 2/3/25.
//

import SwiftUI

struct AddProductScreen: View {
    
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var price: Double?
    
    @Environment(\.dismiss) private var dismiss
    
    @Environment(ProductStore.self) private var productStore
    @AppStorage("userId") private var userId: Int?
    
    private var isFormValid: Bool {
        !name.isEmptyOrWhitespace && !description.isEmptyOrWhitespace && (price ?? 0) > 0
    }
    
    private func saveProduct() async {
        do {
            
            guard let userid = userId else {
                throw ProductSaveError.missingUserId
            }
            guard let price = price else {
                throw ProductSaveError.inavalidPrice
            }
            let product = Product(name: name,
                                  description: description,
                                  price: price,
                                  photoUrl: URL(string: "http://localhost:8080/uploads/star_pest.png")!,
                                  userId: userid)
            try await productStore.saveProduct(product)
            
            dismiss()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        Form {
            TextField("Enter name", text: $name)
            TextEditor(text: $description)
                .frame(height: 100)
            TextField("Enter price", value: $price, format: .number)
        }.toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    Task {
                        await saveProduct()
                    }
                }.disabled(!isFormValid)
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddProductScreen()
    }.environment(ProductStore(httpClient: .development))
}
