//
//  Errors.swift
//  IntelligentShop
//
//  Created by Jason Sanchez on 2/3/25.
//

import Foundation

enum ProductSaveError: Error {
    case missingUserId
    case inavalidPrice
    case operationFailed(String)
    case missingImage
}

enum UserError: Error {
    case missingId
}
