//
//  OrderStore.swift
//  IntelligentShop
//
//  Created by Jason Sanchez on 3/17/25.
//

import Foundation
import Observation

@MainActor
@Observable
class OrderStore {
    
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func saveOrder(order: Order) async throws {
        let body = try JSONSerialization.data(withJSONObject: order.toRequestBody(), options: [])
        let resource = Resource(url: Constants.Urls.createOrder, method: .post(body), modelType: SaveOrderResponse.self)
        let response = try await httpClient.load(resource)
        
        if !response.success {
            throw OrderError.saveFailed(response.message ?? "Unable to save product. Please try again.")
        }
    }
}
