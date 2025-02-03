//
//  ProductStore.swift
//  IntelligentShop
//
//  Created by Jason Sanchez on 1/30/25.
//

import Foundation
import Observation

@Observable
class ProductStore {
    let httpClient: HTTPClient
    private(set) var products: [Product] = []
    private(set) var myProducts: [Product] = []
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func loadAllProducts() async throws {
        let resource = Resource(url: Constants.Urls.products, modelType: [Product].self)
        products = try await httpClient.load(resource)
    }
    
    func saveProduct(_ product: Product) async throws {
        let resource = Resource(url: Constants.Urls.createProducts,
                                method: .post(product.encode()),
                                modelType: CreateProductResponse.self)
        let response = try await httpClient.load(resource)
        if let product = response.product, response.success {
            myProducts.append(product)
        } else {
            throw ProductSaveError.operationFailed(response.message ?? "")
        }
    }
}
