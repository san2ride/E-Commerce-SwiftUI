//
//  Errors.swift
//  IntelligentShop
//
//  Created by Jason Sanchez on 2/3/25.
//

import Foundation

enum ProductError: Error {
    case missingUserId
    case inavalidPrice
    case operationFailed(String)
    case missingImage
    case uploadFailed(String)
    case productNotFound
}

enum UserError: Error {
    case missingId
    case operationFailed(String)
}

enum CartError: Error {
    case operationFailed(String)
}
