//
//  AddProductScreen.swift
//  IntelligentShop
//
//  Created by Jason Sanchez on 2/3/25.
//

import SwiftUI
import PhotosUI

struct AddProductScreen: View {
    
    let product: Product?
    
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var price: Double?
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var isCameraSelected: Bool = false
    @State private var uiImage: UIImage?
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.uploader) private var uploader
    @Environment(ProductStore.self) private var productStore
    @AppStorage("userId") private var userId: Int?
    
    init(product: Product? = nil) {
        self.product = product
    }
    
    private var isFormValid: Bool {
        !name.isEmptyOrWhitespace && !description.isEmptyOrWhitespace && (price ?? 0) > 0
    }
    private func saveOrUpdateProduct() async {
        do {
            guard let uiImage = uiImage, let imageData = uiImage.pngData() else {
                throw ProductError.missingImage
            }
            let uploadDataResonse = try await uploader.upload(data: imageData)
            
            guard let downloadURL = uploadDataResonse.downloadURL, uploadDataResonse.success else {
                throw ProductError.uploadFailed(uploadDataResonse.message ?? "")
            }
            guard let userid = userId else {
                throw ProductError.missingUserId
            }
            guard let price = price else {
                throw ProductError.inavalidPrice
            }
            let product = Product(id: self.product?.id,
                                  name: name,
                                  description: description,
                                  price: price,
                                  photoUrl: downloadURL,
                                  userId: userid)
            if self.product != nil {
                // try await productStore.updateProduct(product)
            } else {
                try await productStore.saveProduct(product)
            }
            try await productStore.saveProduct(product)
            dismiss()
        } catch {
            print(error.localizedDescription)
        }
    }
    private var actionTitle: String {
        product != nil ? "Update Product" : "Add Product"
    }
    
    var body: some View {
        Form {
            TextField("Enter name", text: $name)
            TextEditor(text: $description)
                .frame(height: 100)
            TextField("Enter price", value: $price, format: .number)
            HStack {
                Button(action: {
                    print("camera button")
                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
                        isCameraSelected = true
                    } else {
                        print("Camera is not supported on this device")
                    }
                }, label: {
                    Image(systemName: "camera.fill")
                })
                PhotosPicker(selection: $selectedPhotoItem, matching: .images, photoLibrary: .shared()) {
                    Image(systemName: "photo.on.rectangle")
                }
            }.font(.title2)
            if let uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        .task {
            guard let product = product else { return }
            name = product.name
            description = product.description
            price = product.price
        }
        .task(id: selectedPhotoItem,  {
            if let selectedPhotoItem {
                do {
                    if let data = try await selectedPhotoItem.loadTransferable(type: Data.self) {
                        uiImage = UIImage(data: data)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        })
        .sheet(isPresented: $isCameraSelected, content: {
            ImagePicker(image: $uiImage, sourceType: .camera)
        })
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(actionTitle) {
                    Task {
                        await saveOrUpdateProduct()
                    }
                }.disabled(!isFormValid)
            }
        }
        .navigationTitle(actionTitle)
    }
}

#Preview {
    NavigationStack {
        AddProductScreen()
    }
    .environment(ProductStore(httpClient: .development))
    .environment(\.uploader, Uploader(httpClient: .development))
}

#Preview("Updating Project") {
    NavigationStack {
        AddProductScreen(product: Product.preview)
    }
    .environment(ProductStore(httpClient: .development))
    .environment(\.uploader, Uploader(httpClient: .development))
}
