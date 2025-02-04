//
//  Constants.swift
//  IntelligentShop
//
//  Created by Jason Sanchez on 1/22/25.
//

import Foundation

struct Constants {
    struct Urls {
        static let register: URL = URL(string: "http://localhost:8080/api/auth/register")!
        static let login: URL = URL(string: "http://localhost:8080/api/auth/login")!
        static let products: URL = URL(string: "http://localhost:8080/api/products")!
        static let createProducts: URL = URL(string: "http://localhost:8080/api/products")!
        
        static func myProducts(_ userId: Int) -> URL {
            URL(string: "http://localhost:8080/api/products/user/\(userId)")!
        }
    }
}
