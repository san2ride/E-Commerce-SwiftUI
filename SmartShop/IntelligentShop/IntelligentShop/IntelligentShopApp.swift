//
//  IntelligentShopApp.swift
//  IntelligentShop
//
//  Created by Jason Sanchez on 1/12/25.
//

import SwiftUI

@main
struct IntelligentShopApp: App {
    @State private var productStore = ProductStore(httpClient: HTTPClient())
    @State private var cartStore = CartStore(httpClient: HTTPClient())
    
    @AppStorage("userId") private var userId: String?

    var body: some Scene {
        WindowGroup {
            HomeScreen()
                .environment(\.authenticationController, .development)
                .environment(productStore)
                .environment(cartStore)
                .environment(\.uploaderDownloader, UploaderDownloader(httpClient: HTTPClient()))
                .task(id: userId) {
                    do {
                        if userId != nil {
                            try await cartStore.loadCart()
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
        }
    }
}
