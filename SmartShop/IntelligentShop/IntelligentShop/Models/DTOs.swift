//
//  DTOs.swift
//  IntelligentShop
//
//  Created by Jason Sanchez on 1/22/25.
//

import Foundation

struct RegisterResponse: Codable {
    let message: String?
    let success: Bool
}

struct LoginResponse: Codable {
    let message: String?
    let token: String?
    let success: Bool
    let userId: Int?
    let username: String?
}

struct UploadDataResponse: Codable {
    let message: String?
    let success: Bool
    let downloadURL: URL?
}

struct Product: Codable, Identifiable {
    var id: Int?
    let name: String
    let description: String
    let price: Double
    let photoUrl: URL?
    let userId: Int
    
    private enum CodingKeys: String, CodingKey {
        case id, name, description, price
        case photoUrl = "photo_url"
        case userId = "user_id"
    }
}

extension Product {
    static var preview: Product {
        Product(id: 1, name: "RESIDENTIAL PEST CONTROL",
                description: "We offer comprehensive pest control solutions for your home, ensuring a safe, comfortable environment free from unwanted pests..",
                price: 200,
                photoUrl: URL(string: "http://localhost:8080/uploads/star_pest.png")!,
                userId: 8)
    }
    func encode() -> Data? {
        try? JSONEncoder().encode(self)
    }
}

struct ErrorResponse: Codable {
    let message: String?
}

struct CreateProductResponse: Codable {
    let success: Bool
    let product: Product?
    let message: String?
}
