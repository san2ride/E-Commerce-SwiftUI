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
}
