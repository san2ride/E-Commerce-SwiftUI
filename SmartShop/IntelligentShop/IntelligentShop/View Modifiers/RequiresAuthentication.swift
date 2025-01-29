//
//  RequiresAuthentication.swift
//  IntelligentShop
//
//  Created by Jason Sanchez on 1/28/25.
//

import Foundation
import SwiftUI

struct RequiresAuthentication: ViewModifier {
    
    @State private var isLoading: Bool = true
    @AppStorage("userId") private var userId: String?
    
    func body(content: Content) -> some View {
        Group {
            if isLoading {
                ProgressView("Loading...")
            } else {
                if userId != nil {
                    content
                } else {
                    LoginScreen()
                }
            }
        }.onAppear(perform: checkAuthentication)
    }
    
    private func checkAuthentication() {
        
        guard let token = Keychain<String>.get("jwttoken"), JWTTokenValidator.validate(token: token) else {
            userId = nil
            isLoading = false
            return
        }
        isLoading = false
    }
}

extension View {
    func requiresAuthentication() -> some View {
        modifier(RequiresAuthentication())
    }
}
