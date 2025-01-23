//
//  AuthenticationController.swift
//  IntelligentShop
//
//  Created by Jason Sanchez on 1/22/25.
//

import Foundation

struct AuthenticationController {
    let httpClient: HTTPClient
    
    func register(username: String, password: String) async throws -> RegisterResponse {
        let body = ["username": username, "password": password]
        let bodyData = try JSONEncoder().encode(body)
        
        let resource = Resource(url: Constants.Urls.register, method: .post(bodyData), modelType: RegisterResponse.self)
        let response = try await httpClient.load(resource)
        
        return response
    }
}

extension AuthenticationController {
    static var development: AuthenticationController {
        AuthenticationController(httpClient: HTTPClient())
    }
}
