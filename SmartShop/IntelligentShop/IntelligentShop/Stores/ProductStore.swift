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
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
}
