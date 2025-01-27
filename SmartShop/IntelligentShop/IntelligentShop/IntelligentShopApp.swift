//
//  IntelligentShopApp.swift
//  IntelligentShop
//
//  Created by Jason Sanchez on 1/12/25.
//

import SwiftUI

@main
struct IntelligentShopApp: App {
    @State private var token: String?
    @State private var isLoading: Bool = true
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                Group {
                    if isLoading {
                        ProgressView("Loading...")
                    } else {
                        if JWTTokenValidator.validate(token: token) {
                            Text("HomeScreen")
                        } else {
                            LoginScreen()
                        }
                    }
                }
            }.environment(\.authenticationController, .development)
                .onAppear(perform: {
                    token = Keychain.get("jwttoken")
                    isLoading = false
                })
        }
    }
}
