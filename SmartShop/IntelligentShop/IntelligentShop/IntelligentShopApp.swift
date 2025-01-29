//
//  IntelligentShopApp.swift
//  IntelligentShop
//
//  Created by Jason Sanchez on 1/12/25.
//

import SwiftUI

@main
struct IntelligentShopApp: App {
    var body: some Scene {
        WindowGroup {
                HomeScreen()
            .environment(\.authenticationController, .development)
        }
    }
}
