//
//  CartStore.swift
//  IntelligentShop
//
//  Created by Jason Sanchez on 3/2/25.
//

import Foundation
import Observation

@MainActor
@Observable
class CartStore {
    let httpClient: HTTPClient
    var cart: Cart?
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    func addItemToCart(productId: Int, quantity: Int) async throws {
        let body = ["productId" : productId, "quantity" : quantity]
        let bodyData = try JSONEncoder().encode(body)
        
        let resource = Resource(url: Constants.Urls.addCartItem, method: .post(bodyData), modelType: CartItemResponse.self)
        let response = try await httpClient.load(resource)
        if response.success {
            // do something
        } else {
            // throw an error
        }
    }
    
}
